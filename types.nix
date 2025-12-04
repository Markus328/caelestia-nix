{lib}:
with lib; let
  infuse = import ./infuse.nix {inherit lib;};

  infuseValueType = with types;
    nullOr (oneOf [
      bool
      int
      float
      str
      types.path
      (functionTo infuseValueType)
      (attrsOf infuseValueType)
      (listOf infuseValueType)
    ]);
  infusableType = with types; let
    infusableValue = oneOf [(attrsOf infuseValueType) (functionTo infuseValueType) (listOf infusableValue)];
  in
    infusableValue;

  # makes an option that values can be easily overriden
  mkInfusableOption = default: ignoredAttrs: description:
    mkOption {
      type = infusableType;
      inherit default description;
      apply = userSettings: let
        # Solution to avoid infusing config.nix default (the one without _meta or enable) with generated default (with them).
        infuseSettings = builtins.removeAttrs userSettings ignoredAttrs;
        nonInfuseSettings = getAttrs ignoredAttrs userSettings;
      in
        (infuse default infuseSettings) // nonInfuseSettings;
    };

  mkAlreadyEnabledOption = description:
    mkOption {
      type = types.bool;
      default = true;
      inherit description;
    };

  metadata = mod_name: type: {
    _meta = {
      active = mkAlreadyEnabledOption "Active status of Caelestia ${mod_name} ${type} module";
      type = mkOption {
        type = types.str;
        default = type;
        readOnly = true;
        internal = true;
      };
    };
  };

  importIfActive = mod: module_set: mkIf mod._meta.active (module_set.config or {});
  filterMeta = module_args: module_args // {mod = builtins.removeAttrs module_args.mod ["_meta"];};

  # generate config for any type of module that is fertile, that is, can have submodules (childs).
  mkFertileConfig = parent: mod: module_set: path:
    mkMerge [
      {programs.caelestia-dots = setAttrByPath path {_meta.active = mkDefault ((parent._meta.active or parent.enable) && mod.enable);};}
      (importIfActive mod module_set)
    ];
in {
  # normal modules comes with enable, settings and extraConfig. Overrides goes in settings.
  # burocratic convention, but follows standards and nested submodules are non-confusing.
  normal = let
    mkModOption = default: mod_name: ({
        enable = mkAlreadyEnabledOption "Enable Caelestia ${mod_name} module";

        settings = mkInfusableOption default [] "Caelestia ${mod_name} module settings";
        extraConfig = mkOption {
          type = types.str;
          description = "Caelestia ${mod_name} module extra config";
          default = "";
        };
      }
      // (metadata mod_name "normal"));
  in
    {
      module_set,
      default,
      mod_name,
      mod,
      parent,
      path,
      ...
    }: {
      imports = module_set.imports or [];
      options = mkModOption default mod_name;
      config = mkFertileConfig parent mod module_set path;
    };

  # essentialy an infusable attrs, but with a non-infusable and type-checked _meta option.
  # generally used by modules that doesn't make sense to disable directly and will not have any submodules.
  raw = let
    mkRawModOption = parent: default: mod_name:
      (mkInfusableOption default ["_meta"] "Caelestia ${mod_name} raw module")
      // {
        type = types.submodule ({config, ...}: {
          options = metadata mod_name "raw";

          freeformType = types.attrsOf infuseValueType;

          config = {
            _meta.active = lib.mkDefault (parent._meta.active or parent.enable);
          };
        });
      };
  in
    {
      module_fun,
      module_args,
      parent,
      default,
      mod_name,
      mod,
      ...
    }: {
      options = mkRawModOption parent default mod_name;
      config = importIfActive mod (module_fun (filterMeta module_args));
    };

  # exactly equals to raw, but with an extra enable option. Useful to pass defaults to existent modules.
  pass = let
    mkPassModOption = parent: default: mod_name:
      (mkInfusableOption default ["_meta" "enable"] "Caelestia ${mod_name} pass module")
      // {
        type = types.submodule ({config, ...}: {
          options =
            {
              enable = mkAlreadyEnabledOption "Enable Caelestia ${mod_name} pass module";
            }
            // metadata mod_name "pass";

          freeformType = types.attrsOf infuseValueType;

          config = {
            _meta.active = lib.mkDefault ((parent._meta.active or parent.enable) && config.enable);
          };
        });
      };
  in
    {
      module_fun,
      module_args,
      parent,
      default,
      mod_name,
      mod,
      ...
    }: {
      options = mkPassModOption parent default mod_name;
      config = importIfActive mod (module_fun (filterMeta module_args));
    };

  node = let
    mkNodeOption = node_name:
      {
        enable = mkAlreadyEnabledOption "Enable Caelestia ${node_name} modules";
      }
      // (metadata node_name "node");
  in
    {
      module_set,
      parent,
      default,
      mod_name,
      mod,
      path,
      ...
    }:
      (
        if lib.isAttrs module_set
        then {
          inherit (module_set) imports; # imports required
          config = mkFertileConfig parent mod module_set path;
        }
        else {
          imports = module_set; # can be only a list
          config = mkFertileConfig parent mod {} path; # no config, but using this to manage _meta.active
        }
      )
      // {
        options = mkNodeOption mod_name;
      };
}
