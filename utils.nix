{
  config,
  lib,
  ...
}: {
  mkMod = name: ({
    config,
    lib,
    pkgs,
    ...
  }: let
    mod = config.programs.caelestia-dots.${name};
  in {
    imports = [(import (./configs + "/${name}.nix") {inherit mod name;})];
    options.programs.caelestia-dots.${name} = with lib; {
      enable = mkEnableOption "Enable Caelestia ${name} module";
      settings = mkOption {
        type = types.attrsOf types.anything;
        description = "Caelestia ${name} module settings";
        default = {};
      };
      extraConfig = mkOption {
        type = types.str;
        description = "Caelestia ${name} module extra config";
        default = "{}";
      };
    };
  });
  mkPassMod = from: to: lib.mkAliasOptionModule (["programs" "caelestia-dots"] ++ from) to;
}
