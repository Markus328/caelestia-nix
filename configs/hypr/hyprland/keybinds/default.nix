{
  config,
  lib,
  mod,
  path,
  ...
}: {
  options = prev:
    prev
    // {
      overrides =
        prev.settings
        // {
          description = "Caelestia ${lib.showOption path} module keybind overrides";
          apply = userOverrides: userOverrides;
        };
    };
  config = let
    toHyprconf = attrs: lib.hm.generators.toHyprconf {inherit attrs;};
    unbindAttrs = lib.concatLists (lib.mapAttrsRecursive (path: value: 
    if lib.isListValue value && lib.hasPrefix "bind" (lib.last path) then lib.foldlAttrs (acc: name: value: {
    }) else {}));
    in
  {
    xdg.configFile."hypr/hyprland/keybinds.conf".text =
      (toHyprconf mod.settings) + (toHyprconf mod.overrides) 
  };
}
