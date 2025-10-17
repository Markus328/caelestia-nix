{
  config,
  lib,
  mod,
  ...
}: {
  config = {
    programs.foot = {
      enable = true;
      inherit (mod) settings;
    };
  };
}
