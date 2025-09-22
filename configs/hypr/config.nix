{
  config,
  mod,
  lib,
  ...
}: {
  "$hypr" = "${config.xdg.configHome}/hypr";
  "$hl" = "${config.xdg.configHome}/hypr/hyprland";
  "$cConf" = "${config.xdg.configHome}/caelestia";

  exec = [
    "cp -L --no-preserve=mode --update=none $hypr/scheme/default.conf $hypr/scheme/current.conf"
    # "mkdir -p $cConf && touch -a $cConf/hypr-vars.conf"
  ];

  source = with mod.hyprland;
    [
      "$hypr/scheme/current.conf"
      # "$cConf/hypr-vars.conf"
      "$hypr/variables.conf"
    ]
    ++ lib.optional env.enable "$hl/env.conf"
    ++ lib.optional general.enable "$hl/general.conf"
    ++ lib.optional input.enable "$hl/input.conf"
    ++ lib.optional misc.enable "$hl/misc.conf"
    ++ lib.optional animations.enable "$hl/animations.conf"
    ++ lib.optional decoration.enable "$hl/decoration.conf"
    ++ lib.optional group.enable "$hl/group.conf"
    ++ lib.optional execs.enable "$hl/execs.conf"
    ++ lib.optional rules.enable "$hl/rules.conf"
    ++ lib.optional gestures.enable "$hl/gestures.conf"
    ++ lib.optional keybinds.enable "$hl/keybinds.conf";
}
