{
  config,
  lib,
  mod,
  ...
}: {
  config = {
    programs.starship = mod;
  };
}
