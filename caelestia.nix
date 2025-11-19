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
    ++ (mkMultipleMods {
        parent = [];
        args.type = "pass";
      } [
        ["caelestia" "cli"]
        ["caelestia" "shell"]
      ])
    ++ (mkMultipleMods {parent = [];} [
      "hypr"
      "btop"
      "foot"
      "fish"
    ]);

  options = with lib; {
    programs.caelestia-dots = {
      enable = mkEnableOption "Enable Caelestia dotfiles";
    };
  };
}
