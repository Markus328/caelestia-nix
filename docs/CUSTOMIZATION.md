# Customization

## Defaults

> [!TIP]
> Looking for instructions? Skip this section.

Here there's a list of default configs for each module, use them to guide you through your overrides, they are greatly based (copied) on caelestia-dots, but with some minor substituions and integrations.

- [hypr](../configs/hypr/config.nix)
  - [variables](../configs/hypr/variables/config.nix) (raw)
  - hyprland
    - [env](../configs/hypr/hyprland/env.nix)
    - [general](../configs/hypr/hyprland/general.nix)
    - [input](../configs/hypr/hyprland/input.nix)
    - [misc](../configs/hypr/hyprland/misc.nix)
    - [animations](../configs/hypr/hyprland/animations.nix)
    - [decoration](../configs/hypr/hyprland/decoration.nix)
    - [group](../configs/hypr/hyprland/group.nix)
    - [execs](../configs/hypr/hyprland/execs.nix)
    - [rules](../configs/hypr/hyprland/rules.nix)
    - [gestures](../configs/hypr/hyprland/gestures.nix)
    - [keybinds](../configs/hypr/hyprland/keybinds.nix)
  - [scheme](../configs/hypr/scheme/config.nix) (raw)
- caelestia
  - [shell](../configs/caelestia/shell/config.nix)
  - [cli](../configs/caelestia/cli/config.nix)
- [btop](../configs/btop/config.nix)
- [foot](../configs/foot/config.nix)
- [fish](../configs/fish/config.nix)

## Modules and submodules

This module, come with many submodules (such as caelestia.shell, caelestia.cli and hypr) that can also have other submodules nested.
Each submodule, comes with at least a `enable` and `settings` option, except for some "raw modules" (like `hypr.variables`).

```nix
  programs.caelestia-dots = {
    enable = true;
    hypr.enable = false;
    # hypr.hyprland.keybinds.enable = false; # disabling a parent module will disable all child modules.
    # caelestia.shell.enable = true; # don't need this, all modules are enabled by default.

    # use _active instead of enable to know if a module is actually enabled (this is probably what you want)
    caelestia.cli.enable = config.programs.caelestia-dots.caelestia.shell._active;
  };
```

As you could see, you can disable any module easily, with the correct handling of its submodules as well. Note that, you can explicitly enable a child module and _disable_ its parent module.
The child is enabled but **is not active** due to its parent being disabled. Because of this, you probably want to test against `_active` to know if a module is actually enabled or not.

You can, though, set the `_active` to true, ignoring the parent enabled/disabled state.

## Overriding defaults

Overriding the defaults it's the whole purprose of this module, you and I know well the **caelestia-dots** are great, but you will need some tweak you want or not.

<br>

To override the default settings, you use the `settings` attribute, for each module. That means if you have a module, with nested child submodules, the module and every child can be configured individually.

```nix
  programs.caelestia-dots = {
    enable = true;
    caelestia.shell.settings = {
    # your config goes here, override any default or add new configs.
    }
    hypr.settings = {}; # configs of hypr module
    hypr.hyprland.gestures.settings = {}; # configs of hypr.hyprland.gestures module
  }
```

Looking at the README example, we have:

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

This example, configures some hypr.hyprland.keybinds and caelestia.shell modules, using some "magic" capabilities, such as `__prepend` and the auto append to the list just as `lib.modules` does.

### Infusions

These "magic" capabilities, called sugars, are mainly powered by [infuse.nix](https://codeberg.org/amjoseph/infuse.nix), with some minor tweaks. Your overrides are wrapped, all common declarations (bool, strings, floats and etc) are transformed using `__assign` and for lists, `__append`.
This wrap doesn't prohibits the use of that sugars and others.

<br>

Here is a list of most useful sugars (from infuse.nix + some extensions added by mine):

- `__assign`:
  override or set a value. You probably will not use this, it's wrapped automatically for any leaf that's not a set or function. Argument is anything.
- `__append`:
  append (add to end) of a list. Wrapped automatically for lists. Argument is a list.
- `__prepend`:
  prepend (add to start) of a list. Argument is a list.
- `__remove` (extension):
  remove a string from a list of strings, if the string starts with (lib.hasPrefix) one of the strings of the argument list. Argument is a list of strings.
- `__replace` (extension):
  replace any characters in any string of a list of strings, the argument is a list of replacement lists. A replacement list is a list of strings, the first ones will be matched and substitued by the last one.

<br>

The `__remove` and `__replace` sugars are extensions developed to allow easier edition of lists, like bindings in hypr.hyprland.keybinds.

> [!NOTE]
> These extensions don't have any type checking, if not used exactly how expected, results in undefined behavior.

For more special overrides, you can use the `_:` "operator". It's a function that receives the default value, and you can do anything you want to. It's result completely overwrite the default, even though its a whole set.

```nix
programs.caelestia-dots.hypr.hyprland.general.settings = {
  general.layout = "master";
  dwindle = _: {}; # clear options
# dwindle.__assign = {}; # the same behavior
  master.allow_small_split = true;
};

programs.caelestia-dots.caelestia.shell.settings = {
  # inserts at the third position in the list
  launcher.actions = _:
    (lib.take 3 _) # take the first two elements from default list
    ++ [
      {
        name = "Reload Home Manager";
        description = "Do a home-manager switch";
        command = ["home-manager" "switch"];
        enabled = true;
      }
    ]
    ++ (lib.drop 3 _); # take from the three to the last.
};
```

For more info about infusion, look at the [infuse.nix](https://codeberg.org/amjoseph/infuse.nix) guide.

### Example

> [!NOTE]
> This is only an example to guide your through the overriding process, this is not a recommendation.

<details><summary>example configuration</summary>

```nix
  programs.caelestia-dots = {
    enable = true;
    hypr = {
      variables = {
        editor = "nvim";
        fileExplorer = "dolphin";
        terminal = "footclient";
        kbTerminal = "Ctrl+Alt, a";
        kbTerminalFallback = "Super+Alt, a"; # You can create new vars
      };

      hyprland = {
        gestures.enable = false;
        execs.settings.exec-once = ["foot --server"]; # Append to exec-once
        general.settings = {
          general.layout = "master";
          dwindle = _: {}; # Clear options
          master.allow_small_split = true;
        };

        keybinds.settings = {
          bindl.__remove = [", XF86"]; # Remove all "bindl =, XF86*"
          bind = {
            __append = ["$kbTerminalFallback, exec, foot"]; # Add new binds
            __replace = [
              [", Print" "Shift, Print"] # Edit screenshot bind from ", Print" to "Shift, Print"
              ["resizeactive, exact 55% 70%" "resizeactive, exact 50% 50%"]
            ];
          };
        };

        env.settings.env.__replace = [
          [";xcb" ",x11" ""] # Remove xcb and x11 from toolkit backend related vars
        ];
      };
    };
    caelestia.shell.settings = {
      battery.warnLevels.__prepend = [
        {
          level = 80;
          title = "High Battery";
          message = "Consider unpluging the charger for the battery safety";
          icon = "battery_android_frame_5";
        }
      ]; # Warn when 80% of battery

      launcher.actions = _:
        (lib.take 3 _)
        ++ [
          {
            name = "Reload Home Manager";
            description = "Do a home-manager switch";
            command = ["home-manager" "switch"];
            enabled = true;
          }
        ]
        ++ (lib.drop 3 _); # Insert new action at third position to the launcher
    };
    fish = {
      # All enabled by default
      integrations = {
        starship = false;
        # zoxide = true;
        # eza = true;
        # caelestiaColors = true;
      };
      settings = {
        generateCompletions = false;
      };
    };
  };
```

</details>
