{
  config,
  lib,
  mod,
  ...
}: {
  config = {
    programs.eza = mod;
  };
}
