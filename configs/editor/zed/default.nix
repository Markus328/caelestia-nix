{
  config,
  lib,
  pkgs,
  mod,
  ...
}: {
  config = {
    programs.zed-editor = mod;
    home.packages = with pkgs; [nerd-fonts.caskaydia-cove];
  };
}
