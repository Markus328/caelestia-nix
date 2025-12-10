{
  config,
  lib,
  pkgs,
  mod,
  ...
}: let
  caelesita-vscode-integration = pkgs.callPackage ./caelestia-vscode-integration.nix {};
  extUniqueId = caelesita-vscode-integration.vscodeExtUniqueId;
  vscodeExtDir = "${config.programs.vscode.dataFolderName}/extensions";
in {
  config = {
    programs.vscode = mod;

    # Note that in this way, the extension dir is writable, but not the settings dir.
    # This means the extension cannot change the icon theme dinamically to match the light/dark theme.
    # A solution would be if the icon theme was provided by this extension or the user use some kind of
    # approach to make the settings writable.
    home.activation.caelestiaDotsEnableVscodeIntegration = lib.hm.dag.entryAfter ["linkGeneration"] ''
      cp -Lr --update=none ${caelesita-vscode-integration}/share/vscode/extensions/* ${vscodeExtDir}/${extUniqueId}
      chmod -R 755 ${vscodeExtDir}/${extUniqueId}
    '';
  };
}
