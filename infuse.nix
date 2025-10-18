{lib}: let
  _infuse =
    import
    (builtins.fetchGit {
      url = "https://codeberg.org/amjoseph/infuse.nix";
      name = "infuse.nix";
      rev = "c8fb7397039215e1444c835e36a0da7dc3c743f8";
    }) {
      inherit lib;
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
    };

  inherit (_infuse.v1) infuse;

  # This function will wrap the settings to be used as infusion, allowing a lib.modules like experience
  # with infuse.nix bonus.
  wrapSettingsToInfusion = let
    isSugar = value:
      if lib.isAttrs value
      then let
        attrNames = builtins.attrNames value;
      in
        (builtins.length attrNames > 0) && (lib.hasPrefix "__" (builtins.head attrNames))
      else false;

    transformToInfusion = set:
      if (lib.isFunction set) || isSugar set
      then set
      else if lib.isAttrs set
      then lib.mapAttrs (name: value: transformToInfusion value) set
      else
        # allow ommiting __append or __assign on leafs
        if lib.isList set
        then {__append = set;}
        else {__assign = set;};
  in
    transformToInfusion;
in
  default: userSettings:
    if default != userSettings && userSettings != {}
    then infuse default (wrapSettingsToInfusion userSettings)
    else default
