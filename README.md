# caelestia.nix

This home-manager module provides a declarative way to install and configure [caelestia-dots](https://github.com/caelestia-dots/caelestia) using Nix flakes. It includes default configurations from the caelestia-dots repository, written in Nix, and allows easy customization.

> [!WARNING]
> This module is in a very experimental stage. Many features and modules are still missing, and breaking changes may occur frequently.

---

## Installation

Add `caelestia-nix` (this repository) and `home-manager` as inputs to your flake, and include the module in your home configuration.

### Example `flake.nix`:

```nix

{
  description = "A caelestia-nix test";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    caelestia-nix.url = "github:Markus328/caelestia-nix";
    home-manager.url = "github:nix-community/home-manager";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux"; # Your system here
    pkgs = import nixpkgs {
      inherit system;
    };
  in rec {
    homeConfigurations."user@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home.nix inputs.caelestia-nix.homeManagerModules.default];
    };
  };
}
```

---

## Customization

This module provides default configurations from caelestia-dots. For now, simply enabling the module is enough:

```nix
programs.caelestia-dots.enable = true;
```

You can also deeply configure each module using its "settings" option, such as:

```nix
  programs.caelestia-dots = {
    enable = true;
    hypr.hyprland.keybinds.settings.bind = ["Ctrl+Alt, a, exec, footclient"]; # Appends new bind
    caelestia.shell.settings = {
      launcher.actionPrefix = "."; # Set a value
      battery.warnLevels.__prepend = [ # Prepending to the defaults, without rewriting them all
          {
            level = 80;
            title = "High Battery";
            message = "Consider unpluging the charger for the battery safety";
            icon = "battery_android_frame_5";
          }
        ]; # Warn when 80% of battery
    };
  };
```

<br>

You can configure like you configure any other module option, but you have extras: **sugars**. For deeper instructions, read [CUSTOMIZATION](docs/CUSTOMIZATION.md)

---

## Missing Modules & Future Work

This module is still in early development. For now, only the following modules are implemented:

- hypr
- caelestia

Many modules are planned to be added, all the caelestia dotfiles will be added.

---

## Thanks

- [caelestia-dots](https://github.com/caelestia-dots/caelestia), awesome dotfiles and shell
- [infuse.nix](https://codeberg.org/amjoseph/infuse.nix), greatly enhances customization
