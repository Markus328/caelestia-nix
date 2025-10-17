{
  config,
  lib,
  mod,
  mods,
  path,
  pkgs,
  ...
}: {
  imports = with mods; [
    (mkPassMod (path ++ ["package"]) ["programs" "caelestia" "cli" "package"])
  ];
  config = {
    programs.caelestia.enable = true;
    programs.caelestia.cli = {
      enable = true;
      inherit (mod) settings extraConfig;
    };

    # Theme config (only gtk for now since CLI's qt config depends on qt*ct-kde)
    home.packages = lib.optional mod.settings.theme.enableGtk pkgs.adw-gtk3;
  };
}
