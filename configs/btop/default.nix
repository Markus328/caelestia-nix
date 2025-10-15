{
  config,
  lib,
  mod,
  ...
}: {
  config = {
    programs.btop = {
      enable = true;
      inherit (mod) extraConfig settings;
    };
  };
}
