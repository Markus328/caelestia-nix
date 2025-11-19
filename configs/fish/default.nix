{
  config,
  lib,
  mod,
  use,
  ...
}: let
  mkFishIntegrationOption = name:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fish integration with ${name}";
    };
  fishIntegration = name: {
    "${name}" = lib.mkIf mod.integrations.${name} {
      enable = true;
      enableFishIntegration = true;
    };
  };
in {
  options = {
    # direnv integration is always enabled by default, for some reason
    integrations = {
      starship = mkFishIntegrationOption "starship";
      zoxide = mkFishIntegrationOption "zoxide";
      eza = mkFishIntegrationOption "eza (better ls)";

      # By default, its enabled, according to caelestia.cli defaults
      caelestiaColors = mkFishIntegrationOption "caelestia colors" // {default = use "caelestia.cli" "settings.theme.enableTerm" false;};
    };
  };
  config = {
    programs = lib.mkMerge [
      {
        fish.enable = true;
      }
      (fishIntegration "starship")
      (fishIntegration "zoxide")
      (fishIntegration "eza")
      (lib.mkIf mod.integrations.caelestiaColors {
        fish.shellInitLast = ''
          cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
        '';
      })
      {
        fish = mod.settings;

        eza = {
          icons = "always";
          colors = "always";
        };
      }
    ];
  };
}
