{
  config,
  lib,
  mod,
  ...
}: {
  config = {
    programs.fish = mod;
  };
}
