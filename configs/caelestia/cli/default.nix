{
  config,
  lib,
  mod,
  mods,
  path,
  ...
}: {
  imports = with mods; [
    (mkPassMod (path ++ ["package"]) ["programs" "caelestia" "cli" "package"])
  ];
  config = {
    programs.caelestia.enable = true;
    programs.caelestia.cli = {
      enable = true;
      inherit (mod) settings extraConfig;
    };
  };
}
