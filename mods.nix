{lib}: let
  mods = rec {
    _make_module = {
      path,
      root ? ./configs,
      raw ? false,
    }: ({
      config,
      lib,
      pkgs,
      ...
    }: let
      mod = lib.getAttrFromPath path config.programs.caelestia-dots;
      mod_name = lib.showOption path;
      mod_path = lib.path.append root (lib.path.subpath.join path);
      default = import (lib.path.append mod_path "config.nix") {inherit config lib mod;};
    in {
      imports = [(import mod_path {inherit mod path mods;})];
      options.programs.caelestia-dots = lib.setAttrByPath path (with lib;
        if raw
        then
          (mkOption {
            type = types.attrsOf types.anything;
            description = "Caelestia ${mod_name} module";
            inherit default;
            apply = userSettings: lib.recursiveUpdate default userSettings;
          })
        else {
          enable = mkEnableOption "Enable Caelestia ${mod_name} module";
          settings = mkOption {
            type = types.attrsOf types.anything;
            description = "Caelestia ${mod_name} module settings";
            inherit default;
            apply = userSettings: lib.recursiveUpdate default userSettings;
          };
          extraConfig = mkOption {
            type = types.str;
            description = "Caelestia ${mod_name} module extra config";
            default = "";
          };
        });
    });

    mkMod = path: _make_module {inherit path;};
    mkRawMod = path:
      _make_module {
        inherit path;
        raw = true;
      };

    mkPassMod = from: to: lib.mkAliasOptionModule (["programs" "caelestia-dots"] ++ from) to;

    mkMultipleMods = {
      args ? {},
      parent,
    }: paths:
      map (path: _make_module (args // {path = parent ++ path;})) paths;
  };
in
  mods
