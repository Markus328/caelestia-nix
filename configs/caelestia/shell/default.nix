{
  config,
  lib,
  mod,
  ...
}: {
  config = {
    programs.caelestia = mod // {cli = {};};
  };
}
