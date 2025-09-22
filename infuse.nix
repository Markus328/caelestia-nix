{lib}: let
  infuse =
    (import
      (builtins.fetchGit {
        url = "https://codeberg.org/amjoseph/infuse.nix";
        name = "infuse.nix";
        rev = "c8fb7397039215e1444c835e36a0da7dc3c743f8";
      }) {inherit lib;}).v1.infuse;

  # This function will wrap the settings to be used as infusion, allowing a lib.modules like experience
  # with infuse.nix bonus.
  wrapSettingsToInfusion = let
    isSugar = value:
      if lib.isAttrs value
      then let
        attrNames = builtins.attrNames value;
      in
        (builtins.length attrNames == 1)
        && (lib.hasPrefix "__" (builtins.head attrNames))
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
  default: userSettings: infuse default (wrapSettingsToInfusion userSettings)
