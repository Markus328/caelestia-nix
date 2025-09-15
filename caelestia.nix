inputs: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.caelestia-dots;
  mods = import ./mods.nix {inherit lib;};
in {
  imports = with mods; [
    inputs.caelestia-shell.homeManagerModules.default
    (mkPassMod ["shell"] ["programs" "caelestia"])
    (mkPassMod ["cli"] ["programs" "caelestia" "cli"])
  ];

  options = with lib; {
    programs.caelestia-dots = {
      enable = mkEnableOption "Enable Caelestia dotfiles";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.caelestia.enable = lib.mkDefault true;
  };
}
