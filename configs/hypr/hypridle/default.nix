{
  config,
  lib,
  mod,
  ...
}: {
  config = {
    services.hypridle = {
      enable = true;
      settings = mod.settings;
    };
  };
}
