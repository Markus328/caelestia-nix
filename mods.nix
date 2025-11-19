{lib}: let
  opts = import ./options.nix {inherit lib;};

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
        dots = config.programs.caelestia-dots;
        parent = lib.getAttrFromPath parentPath dots; # parent module, used to control active state
        path = parentPath ++ subPath; # module path, useful for passing to nested _make_module
        mod = lib.getAttrFromPath path dots; # the actual module config

        isNormalMod = !(type == "raw" || type == "pass");

        mod_name = lib.showOption path;
        mod_dir = lib.path.append root (lib.path.subpath.join path); # directory where the module is stored

        # the set of the module, after passing all the module arguments. Imports from `mod_dir` if `module` is null
        module_set = let
          clean_mod = builtins.removeAttrs mod (
            if !isNormalMod
            then ["_meta"] # remove _meta from non-normal modules to avoid mixing metadata with configs.
            else []
          );
          module_args = {
            inherit config lib pkgs options path mods dots use;
            mod = clean_mod;
          };
        in
          if module != null
          then module module_args
          else import mod_dir module_args;

        # the default config of module, imported directly from `mod_path` / config.nix if `cfg` is null
        default = let
          cfg_args = {inherit config lib pkgs options mod dots use;};
        in
          if cfg != null
          then cfg cfg_args
          else import (lib.path.append mod_dir "config.nix") cfg_args;

        # function that takes any other module's option or use a fallback if that module is not active
        # first two arguments are purely module names, makes syntax a bit cleaner
        use = modulePath: settingPath: fallback: let
          module = lib.getAttrFromPath (lib.splitString "." modulePath) dots;
          sett =
            if module._meta.type == "normal"
            then module.settings
            else module;
          opt = lib.getAttrFromPath (lib.splitString "." settingPath) sett;
        in
          if module._meta.active
          then opt
          else fallback;
      in {
        imports = module_set.imports or [];

        # creates options for the desired type of moudule
        options.programs.caelestia-dots = lib.setAttrByPath path (lib.recursiveUpdate (
          opts.options.${type} parent default mod_name
        ) (module_set.options or {}));

        config = with lib;
          mkMerge [
            # _meta.active default value is true if the module is enabled and its parent is active. The value can be overriden by user.
            # non-normal modules set their own active state default in options.nix
            {programs.caelestia-dots = setAttrByPath path {_meta.active = mkIf isNormalMod (mkDefault ((parent._meta.active or parent.enable) && mod.enable));};}
            (mkIf mod._meta.active (module_set.config or {}))
          ];
      }
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
