inputs: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.caelestia-dots;
  mods = import ./mods.nix {inherit lib;};
in {
  imports = with mods;
    [
      inputs.caelestia-shell.homeManagerModules.default
      # (mkMod ["caelestia" "shell"])
      # (mkMod ["caelestia" "cli"])
    ]
    ++ (mkMultipleMods {parent = [];} [
      "hypr"
      ["caelestia" "cli"]
      ["caelestia" "shell"]
    ]);

  options = with lib; {
    programs.caelestia-dots = {
      enable = mkEnableOption "Enable Caelestia dotfiles";
    };
  };
}
