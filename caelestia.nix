inputs: {
  config,
  lib,
  pkgs,
  ...
}: let
  mods = import ./mods.nix {inherit lib;};
in {
  imports = with mods;
    [
      inputs.caelestia-shell.homeManagerModules.default
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
