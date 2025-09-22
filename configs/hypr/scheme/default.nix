{
  config,
  lib,
  mod,
  ...
}: let
  schemeCfg = lib.hm.generators.toHyprconf {
    attrs =
      lib.concatMapAttrs (name: value: {
        "\$${name}" = value;
      })
      mod;
  };
  schemePath = "hypr/scheme";
in {
  config = {
    xdg.configFile."${schemePath}/default.conf".text = schemeCfg;
    home.activation.caelestiaDotsHyprCurrentScheme = lib.hm.dag.entryAfter ["linkGeneration"] ''
      cp -L --no-preserve=mode --update=none ${config.xdg.configFile."${schemePath}/default.conf".source} ${config.xdg.configHome}/${schemePath}/current.conf
    ''; # Avoid Hyprland first launch sourcing error, looks like the exec in hyprland.conf is not enough.
  };
}
