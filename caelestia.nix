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
    ++ (mkMultipleMods {parentPath = [];} [
      "hypr"
      (mkNode [] "caelestia")
      "btop"
      "foot"
      (mkNode [] "term")
    ]);

  options = with lib; {
    programs.caelestia-dots = {
      enable = mkEnableOption "Enable Caelestia dotfiles";
    };
  };
}
