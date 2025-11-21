{lib}: let
  sugars =
    _infuse.v1.default-sugars
    ++ lib.attrsToList {
      __remove = path: remove: target: lib.filter (tg: !lib.any (r: lib.hasPrefix r tg) remove) target; # Remove all strings starting with any remove list strings.
      __replace = path: replace: target:
      # Replace all strings from replacement list to the last one in each list.
        with lib.lists; let
          froms = flatten (map (frs: dropEnd 1 frs) replace);
          tos = flatten (map (ts: replicate (builtins.length ts - 1) (last ts)) replace);
        in
          map (
            tg:
              builtins.replaceStrings froms tos tg
          )
          target;
    };
  _infuse =
    import
    (builtins.fetchGit {
      url = "https://codeberg.org/amjoseph/infuse.nix";
      name = "infuse.nix";
      rev = "c8fb7397039215e1444c835e36a0da7dc3c743f8";
    }) {
      inherit lib sugars;
    };

  inherit (_infuse.v1) infuse;

  # This function will wrap the settings to be used as infusion, allowing a lib.modules like experience
  # with infuse.nix bonus.
  wrapSettingsToInfusion = let
    isSugar = name: lib.any (s: s.name == name) sugars;
    isSpecial = lib.hasPrefix "__";

    # an attrs is valid if has no sugars or has only sugars
    isValidAttrs = value:
      with lib; let
        attrNames = builtins.attrNames value;
        sugarCount = count isSugar attrNames;
        hasSpecial = any isSpecial attrNames;
      in
        isAttrs value && ((sugarCount == 0 && !hasSpecial) || sugarCount == lists.length attrNames);

    transformToInfusion = name: value:
      if (lib.isFunction value) || (isSugar name && !lib.isAttrs value) || name == "__assign"
      then value
      else if isValidAttrs value
      then lib.mapAttrs (n: v: transformToInfusion n v) value
      else if lib.isList value
      then {__append = value;}
      else {__assign = value;};
  in
    transformToInfusion;
in
  default: userSettings:
    if default != userSettings && userSettings != {}
    then infuse default (wrapSettingsToInfusion "" userSettings)
    else default
