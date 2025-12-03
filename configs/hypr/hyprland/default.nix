{
  path,
  mods,
  ...
}: let
  mkHyprConfs = confs:
    map (conf: let
      cfg = import (./. + "/${conf}.nix");
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
        subPath = conf;
      })
    confs;
in
  mkHyprConfs [
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
  ]
