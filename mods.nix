{lib}: let
  types = import ./types.nix {inherit lib;};

  mods = rec {
    _make_module = {
      parentPath,
      subPath,
      root ? ./configs,
      type ? "normal",
      module ? null,
      cfg ? null,
    }: (
      {
        config,
        lib,
        pkgs,
        options,
        ...
      }: let
        args = rec {
          dots = config.programs.caelestia-dots;
          parent = lib.getAttrFromPath parentPath dots; # parent module, used to control active state
          path = parentPath ++ subPath; # module path, useful for passing to nested _make_module
          mod = lib.getAttrFromPath path dots; # the actual module config

          mod_name = lib.showOption path;
          mod_dir = lib.path.append root (lib.path.subpath.join path); # directory where the module is stored

          module_args = {
            inherit config lib pkgs mod options path mods dots withMod use ifActive;
          };
          module_fun =
            if module != null
            then module
            else import mod_dir;

          # the set of the module, after passing all the module arguments. Imports from `mod_dir` if `module` is null
          module_set = module_fun module_args;

          # the default config of module, imported directly from `mod_path` / config.nix if `cfg` is null
          default = let
            cfg_args = {inherit config lib pkgs options mod dots withMod use ifActive;};
          in
            if cfg != null
            then cfg cfg_args
            else import (lib.path.append mod_dir "config.nix") cfg_args;

          # apply expression on fun with module arg if is active
          withMod = modulePath: fn: fallback: let
            module = lib.getAttrFromPath (lib.splitString "." modulePath) dots;
            active = module._meta.active;
          in
            if active
            then fn module
            else fallback;

          # function that takes any other module's option or use a fallback if that module is not active
          use = modulePath: settingPath: fallback:
            withMod modulePath (module: let
              sett =
                if module._meta.type == "normal"
                then module.settings
                else module;
              opt = lib.getAttrFromPath (lib.splitString "." settingPath) sett;
            in
              opt)
            fallback;

          # apply expression conditionally if module is active
          ifActive = modulePath: _then: _else: withMod modulePath (_: _then) _else;
        };

        imported_mod_type = types.${type} args;
      in (imported_mod_type
        // {
          options = lib.setAttrByPath (["programs" "caelestia-dots"] ++ args.path) imported_mod_type.options;
        })
    );

    mkMod = parentPath: subPath: _make_module {inherit parentPath subPath;};
    mkRawMod = parentPath: subPath:
      _make_module {
        inherit parentPath subPath;
        type = "raw";
      };

    mkPassMod = parentPath: subPath:
      _make_module {
        inherit parentPath subPath;
        type = "pass";
      };

    mkNode = parentPath: subPath:
      _make_module {
        inherit parentPath subPath;
        type = "node";
      };

    mkMultipleMods = {
      args ? {},
      parent ? [],
    }: paths:
      map (path:
        _make_module (args
          // {
            parentPath = parent;
            subPath = lib.toList path;
          }))
      paths;
  };
in
  mods
