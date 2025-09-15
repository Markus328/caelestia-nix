{lib}: {
  mkMod = path: ({
    config,
    lib,
    pkgs,
    ...
  }: let
    mod = lib.getAttrFromPath path config.programs.caelestia-dots;
    mod_name = lib.showOption path;
    mod_path = lib.path.append ./configs (lib.path.subpath.join path);
    default = import (lib.path.append mod_path "config.nix") {inherit config lib mod;};
  in {
    imports = [(import mod_path {inherit mod path;})];
    options.programs.caelestia-dots = lib.setAttrByPath path (with lib; {
      enable = mkEnableOption "Enable Caelestia ${mod_name} module";
      settings = mkOption {
        type = types.attrsOf types.anything;
        description = "Caelestia ${mod_name} module settings";
        inherit default;
        apply = userSettings: lib.recursiveUpdate default userSettings;
      };
      extraConfig = mkOption {
        type = types.str;
        description = "Caelestia ${mod_name} module extra config";
        default = "";
      };
    });
  });
  mkPassMod = from: to: lib.mkAliasOptionModule (["programs" "caelestia-dots"] ++ from) to;

  mkRawMod = path: ({
    config,
    lib,
    pkgs,
    ...
  }: let
    mod = lib.getAttrFromPath path config.programs.caelestia-dots;
    mod_path = lib.path.append ./configs (lib.path.subpath.join path);
    mod_name = lib.showOption path;
    default = import (lib.path.append mod_path "config.nix") {inherit config lib mod;};
  in {
    imports = [(import mod_path {inherit mod path;})];
    options.programs.caelestia-dots = lib.setAttrByPath path (with lib;
      mkOption {
        type = types.attrsOf types.anything;
        description = "Caelestia ${mod_name} module";
        inherit default;
        apply = userSettings: lib.recursiveUpdate default userSettings;
      });
  });
}
