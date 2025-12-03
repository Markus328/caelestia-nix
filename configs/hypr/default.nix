{
  config,
  lib,
  mod,
  path,
  mods,
  pkgs,
  use,
  ...
}: {
  # Hypr module

  imports = with mods; [
    (mkRawMod path ["variables"]) # variables.conf
    (mkRawMod path ["scheme"]) # scheme/default.conf
    (mkNode path ["hyprland"])
  ];
  config = {
    wayland.systemd.target = "hyprland-session.target";
    wayland.windowManager.hyprland = {
      enable = true;
      sourceFirst = false;
      settings = mod.settings;
      systemd.variables = with lib; map (env: head (splitString "," env)) (use "hypr.hyprland.env" "env" []);
    };

    services = {
      gnome-keyring.enable = true;
      polkit-gnome.enable = true;
      gammastep = {
        enable = true;
        provider = "geoclue2";
      };
      cliphist.enable = true;
    };

    home.pointerCursor = {
      enable = true;
      name = mod.variables.cursorTheme;
      size = mod.variables.cursorSize;
      gtk.enable = true;
      package =
        lib.mkIf (mod.variables.cursorTheme == "Sweet-cursors")
        pkgs.sweet-nova;
    };
  };
}
