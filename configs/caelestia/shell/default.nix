{
  config,
  lib,
  mod,
  mods,
  path,
  ...
}: {
  imports = with mods; [
    (mkPassMod (path ++ ["systemd"]) ["programs" "caelestia" "systemd"])
    (mkPassMod (path ++ ["package"]) ["programs" "caelestia" "package"])
  ];
  config = {
    programs.caelestia = {
      enable = true;
      inherit (mod) settings extraConfig;
    };
  };
}
