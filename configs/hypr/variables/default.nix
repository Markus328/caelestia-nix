{
  config,
  lib,
  mod,
  ...
}: {
  config = {
    xdg.configFile."hypr/variables.conf".text = lib.hm.generators.toHyprconf {
      attrs =
        lib.concatMapAttrs (name: value: {
          "\$${name}" = value;
        })
        mod;
    };
  };
}
