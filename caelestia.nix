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
        ["term" "fish"]
        ["term" "starship"]
        ["term" "eza"]
      ])
    ++ (mkMultipleMods {parent = [];} [
      "hypr"
      "btop"
      "foot"
    ])
    ++ [(mkNode [] ["caelestia"])];

  options = with lib; {
    programs.caelestia-dots = {
      enable = mkEnableOption "Enable Caelestia dotfiles";
    };
  };
}
