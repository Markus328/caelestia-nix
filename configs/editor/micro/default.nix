{
  config,
  lib,
  pkgs,
  mod,
  ...
}: {
  config = {
    programs.micro = {
      enable = true;
      inherit (mod) settings;
    };
  };
}
