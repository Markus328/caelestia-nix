{
  config,
  lib,
  mod,
  pkgs,
  ...
}: {
  config = {
    programs.caelestia.enable = true;
    programs.caelestia.cli = mod;

    # Theme config (only gtk for now since CLI's qt config depends on qt*ct-kde)
    home.packages = lib.optional mod.settings.theme.enableGtk pkgs.adw-gtk3;
    gtk = {
      iconTheme.package = pkgs.papirus-icon-theme;
    };
  };
}
