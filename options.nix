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
in rec {
  # makes an option that values can be easily overriden
  mkInfusableOption = default: description:
    mkOption {
      type = infusableType;
      inherit default description;
      apply = userSettings: infuse default userSettings;
    };

  # essentialy an infusable attrs, but with an non-infusable and type-checked _meta options.
  # generally used by modules that doesn't make sense to disable directly and will not have any submodules.
  mkRawModOption = parent: default: mod_name:
    (mkInfusableOption default "Caelestia ${mod_name} raw module")
    // {
      type = types.submodule ({config, ...}: {
        options = metadata mod_name "raw";

        freeformType = types.attrsOf infuseValueType;

        config = {
          _meta.active = lib.mkDefault (parent._meta.active or parent.enable);
        };
      });
    };

  # normal modules comes with enable, settings and extraConfig. Overrides goes in settings.
  # burocratic convention, but follows standards and nested submodules are non-confusing.
  mkModOption = parent: default: mod_name: ({
      enable = mkAlreadyEnabledOption "Enable Caelestia ${mod_name} module";

      settings = mkInfusableOption default "Caelestia ${mod_name} module settings";
      extraConfig = mkOption {
        type = types.str;
        description = "Caelestia ${mod_name} module extra config";
        default = "";
      };
    }
    // (metadata mod_name "normal"));

  # exactly equals to mkRawModOption, but with an extra enable option. Useful to pass defaults to existent modules.
  mkPassModOption = parent: default: mod_name:
    (mkInfusableOption default "Caelestia ${mod_name} pass module")
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

  options = {
    normal = mkModOption;
    raw = mkRawModOption;
    pass = mkPassModOption;
  };
}
