{
  config,
  lib,
  mod,
  path,
  mods,
  ...
}: let
  mkHyprConfs = confs:
    map (conf: let
      cfg = import (./hyprland + "/${conf}.nix");
      module = {
        config,
        lib,
        mod,
        ...
      }: {
        config.xdg.configFile."hypr/hyprland/${conf}.conf".text = lib.hm.generators.toHyprconf {attrs = mod.settings;};
      };
    in
      mods._make_module {
        inherit cfg module;
        parentPath = path;
        subPath = ["hyprland" conf];
      })
    confs;
in {
  # Hypr module

  imports = with mods;
    [
      (mkRawMod path ["variables"]) # variables.conf
      (mkRawMod path ["scheme"]) # scheme/default.conf
    ]
    ++ mkHyprConfs [
      "env"
      "general"
      "input"
      "misc"
      "animations"
      "decoration"
      "group"
      "execs"
      "rules"
      "gestures"
      "keybinds"
    ];
  config = {
    wayland.systemd.target = "hyprland-session.target";
    wayland.windowManager.hyprland = {
      enable = true;
      sourceFirst = false;
      settings = mod.settings;
    };

    services = {
      gnome-keyring.enable = true;
      polkit-gnome.enable = true;
      gammastep = {
        enable = true;
        provider = "geoclue2";
      };
    };
    dconf = {
      settings = {
        "org/gnome/desktop/interface" = {
          cursor-theme = mod.variables.cursorTheme;
          cursor-size = mod.variables.cursorSize;
        };
      };
    };
  };
}
