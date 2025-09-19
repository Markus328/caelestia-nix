{lib}: let
  mods = rec {
    _make_module = {
      parentPath,
      subPath,
      root ? ./configs,
      raw ? false,
      module ? null,
      cfg ? null,
    }: (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        parent = lib.getAttrFromPath parentPath config.programs.caelestia-dots;
        path = parentPath ++ subPath;
        mod = lib.getAttrFromPath path config.programs.caelestia-dots;
        mod_name = lib.showOption path;
        mod_path = lib.path.append root (lib.path.subpath.join path);
        module_set =
          if module != null
          then module {inherit config lib pkgs mod path mods;}
          else import mod_path {inherit config lib pkgs mod path mods;};
        default =
          if cfg != null
          then cfg {inherit config lib mod pkgs;}
          else import (lib.path.append mod_path "config.nix") {inherit config lib mod pkgs;};
      in {
        imports = module_set.imports or [];
        options.programs.caelestia-dots = lib.recursiveUpdate (lib.setAttrByPath path (with lib;
          if raw
          then
            (mkOption {
              type = types.attrsOf types.anything;
              description = "Caelestia ${mod_name} module";
              inherit default;
              apply = userSettings: lib.recursiveUpdate default userSettings;
            })
          else {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Enable Caelestia ${mod_name} module";
            };
            _active = mkEnableOption "Set active status of Caelestia ${mod_name} module";
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
          })) (module_set.options or {});
        config = lib.mkIf ((parent._active or parent.enable) && (raw || mod.enable)) (lib.mkMerge [
          {programs.caelestia-dots = lib.setAttrByPath path {_active = lib.mkDefault true;};}
          (module_set.config or {})
        ]);
      }
    );

    mkMod = parentPath: subPath: _make_module {inherit parentPath subPath;};
    mkRawMod = parentPath: subPath:
      _make_module {
        inherit parentPath subPath;
        raw = true;
      };

    mkPassMod = from: to: lib.mkAliasOptionModule (["programs" "caelestia-dots"] ++ from) to;

    mkMultipleMods = {
      args ? {},
      parent ? [],
    }: paths:
      map (path:
        _make_module (args
          // {
            parentPath = parent;
            subPath =
              if lib.isList path
              then path
              else [path];
          }))
      paths;
  };
in
  mods
