{lib}: let
  infuse = import ./infuse.nix {inherit lib;};
  mods = rec {
    # makes an option that values can be easily overriden
    mkInfusableOption = default: description:
      with lib;
        mkOption {
          type = with types; let
            valueType = nullOr (oneOf [
              bool
              int
              float
              str
              types.path
              (functionTo valueType)
              (attrsOf valueType)
              (listOf valueType)
            ]);
            infusableValue = oneOf [(attrsOf valueType) (functionTo valueType) (listOf infusableValue)];
          in
            infusableValue;
          inherit default description;
          apply = userSettings: infuse default userSettings;
        };

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
        dots = config.programs.caelestia-dots;
        parent = lib.getAttrFromPath parentPath dots; # parent mod, used to control active state
        path = parentPath ++ subPath; # mod path, useful for passing to nested _make_module
        mod = lib.getAttrFromPath path dots; # the actual mod config

        mod_name = lib.showOption path;
        mod_dir = lib.path.append root (lib.path.subpath.join path); # directory where the module is stored

        # the set of the module, after passing all the module arguments. Imports from `mod_dir` if `module` is null
        module_set = let
          module_args = {inherit config lib pkgs mod path mods dots use;};
        in
          if module != null
          then module module_args
          else import mod_dir module_args;

        # the default config of module, imported directly from `mod_path` / config.nix if `cfg` is null
        default = let
          cfg_args = {inherit config lib pkgs mod dots use;};
        in
          if cfg != null
          then cfg cfg_args
          else import (lib.path.append mod_dir "config.nix") cfg_args;

        # function that takes any other module's option or use a fallback if that module is not active
        # First two argument are purely module names, makes syntax a bit cleaner
        use = modulePath: settingPath: fallback: let
          module = lib.getAttrFromPath (lib.splitString "." modulePath) dots;
          sett =
            if module ? enable
            then module.settings or module
            else module;
          opt = lib.getAttrFromPath (lib.splitString "." settingPath) sett;
        in
          if module._active or true
          then opt
          else fallback;
      in {
        imports = module_set.imports or [];

        # creates default options for each module
        options.programs.caelestia-dots = lib.setAttrByPath path (lib.recursiveUpdate (with lib;
          if raw
          then
            # raw modules are just infusable values, overrides goes in the toplevel
            mkInfusableOption default "Caelestia ${mod_name} module"
          else {
            # normal modules comes with enable, settings and extraConfig. Overrides goes in settings
            # other options can be added in module_set
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Enable Caelestia ${mod_name} module";
            };
            _active = mkEnableOption "Set active status of Caelestia ${mod_name} module";
            settings = mkInfusableOption default "Caelestia ${mod_name} module settings";
            extraConfig = mkOption {
              type = types.str;
              description = "Caelestia ${mod_name} module extra config";
              default = "";
            };
          }) (module_set.options or {}));

        # checks module and parent enabled states, sets active state and imports modules_set configs conditionally.
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
            subPath = lib.toList path;
          }))
      paths;
  };
in
  mods
