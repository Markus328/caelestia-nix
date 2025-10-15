{
  config,
  mod,
  dots,
  ...
}: {
  appearance = {
    anim = {
      durations = {
        scale = 1;
      };
    };
    font = {
      family = {
        clock = "Rubik";
        material = "Material Symbols Rounded";
        mono = "CaskaydiaCove NF";
        sans = "Rubik";
      };
      size = {
        scale = 1;
      };
    };
    padding = {
      scale = 1;
    };
    rounding = {
      scale = 1;
    };
    spacing = {
      scale = 1;
    };
    transparency = {
      base = 0.85;
      enabled = false;
      layers = 0.4;
    };
  };
  background = {
    desktopClock = {
      enabled = false;
    };
    enabled = true;
    visualiser = {
      autoHide = true;
      enabled = false;
      rounding = 1;
      spacing = 1;
    };
  };
  bar = {
    clock = {
      showIcon = true;
    };
    dragThreshold = 20;
    entries = [
      {
        enabled = true;
        id = "logo";
      }
      {
        enabled = true;
        id = "workspaces";
      }
      {
        enabled = true;
        id = "spacer";
      }
      {
        enabled = true;
        id = "activeWindow";
      }
      {
        enabled = true;
        id = "spacer";
      }
      {
        enabled = true;
        id = "tray";
      }
      {
        enabled = true;
        id = "clock";
      }
      {
        enabled = true;
        id = "statusIcons";
      }
      {
        enabled = true;
        id = "power";
      }
    ];
    persistent = true;
    scrollActions = {
      brightness = true;
      volume = true;
      workspaces = true;
    };
    showOnHover = true;
    status = {
      showAudio = false;
      showBattery = true;
      showBluetooth = true;
      showKbLayout = false;
      showLockStatus = true;
      showMicrophone = false;
      showNetwork = true;
    };
    tray = {
      background = false;
      compact = false;
      iconSubs = [];
      recolour = false;
    };
    workspaces = {
      activeIndicator = true;
      activeLabel = "󰮯";
      activeTrail = false;
      label = "  ";
      occupiedBg = false;
      occupiedLabel = "󰮯";
      perMonitorWorkspaces = true;
      showWindows = true;
      shown = 5;
      specialWorkspaceIcons = [
        {
          icon = "sports_esports";
          name = "steam";
        }
      ];
    };
  };
  border = {
    rounding = 25;
    thickness = 10;
  };
  dashboard = {
    dragThreshold = 50;
    enabled = true;
    mediaUpdateInterval = 500;
    showOnHover = true;
  };
  general = {
    apps = {
      audio = ["pavucontrol"];
      explorer = [dots.hypr.variables.fileExplorer];
      playback = ["mpv"];
      terminal = [dots.hypr.variables.terminal];
    };
    battery = {
      criticalLevel = 3;
      warnLevels = [
        {
          icon = "battery_android_frame_2";
          level = 20;
          message = "You might want to plug in a charger";
          title = "Low battery";
        }
        {
          icon = "battery_android_frame_1";
          level = 10;
          message = "You should probably plug in a charger <b>now</b>";
          title = "Did you see the previous message?";
        }
        {
          critical = true;
          icon = "battery_android_alert";
          level = 5;
          message = "PLUG THE CHARGER RIGHT NOW!!";
          title = "Critical battery level";
        }
      ];
    };
    idle = {
      inhibitWhenAudio = true;
      lockBeforeSleep = true;
      timeouts = [
        {
          idleAction = "lock";
          timeout = 180;
        }
        {
          idleAction = "dpms off";
          returnAction = "dpms on";
          timeout = 300;
        }
        {
          idleAction = [
            "systemctl"
            "suspend-then-hibernate"
          ];
          timeout = 600;
        }
      ];
    };
  };
  launcher = {
    actionPrefix = ">";
    actions = [
      {
        command = [
          "autocomplete"
          "calc"
        ];
        dangerous = false;
        description = "Do simple math equations (powered by Qalc)";
        enabled = true;
        icon = "calculate";
        name = "Calculator";
      }
      {
        command = [
          "autocomplete"
          "scheme"
        ];
        dangerous = false;
        description = "Change the current colour scheme";
        enabled = true;
        icon = "palette";
        name = "Scheme";
      }
      {
        command = [
          "autocomplete"
          "wallpaper"
        ];
        dangerous = false;
        description = "Change the current wallpaper";
        enabled = true;
        icon = "image";
        name = "Wallpaper";
      }
      {
        command = [
          "autocomplete"
          "variant"
        ];
        dangerous = false;
        description = "Change the current scheme variant";
        enabled = true;
        icon = "colors";
        name = "Variant";
      }
      {
        command = [
          "autocomplete"
          "transparency"
        ];
        dangerous = false;
        description = "Change shell transparency";
        enabled = false;
        icon = "opacity";
        name = "Transparency";
      }
      {
        command = [
          "${dots.caelestia.cli.package}/bin/caelestia"
          "wallpaper"
          "-r"
        ];
        dangerous = false;
        description = "Switch to a random wallpaper";
        enabled = true;
        icon = "casino";
        name = "Random";
      }
      {
        command = [
          "setMode"
          "light"
        ];
        dangerous = false;
        description = "Change the scheme to light mode";
        enabled = true;
        icon = "light_mode";
        name = "Light";
      }
      {
        command = [
          "setMode"
          "dark"
        ];
        dangerous = false;
        description = "Change the scheme to dark mode";
        enabled = true;
        icon = "dark_mode";
        name = "Dark";
      }
      {
        command = [
          "systemctl"
          "poweroff"
        ];
        dangerous = true;
        description = "Shutdown the system";
        enabled = true;
        icon = "power_settings_new";
        name = "Shutdown";
      }
      {
        command = [
          "systemctl"
          "reboot"
        ];
        dangerous = true;
        description = "Reboot the system";
        enabled = true;
        icon = "cached";
        name = "Reboot";
      }
      {
        command = [
          "loginctl"
          "terminate-user"
          ""
        ];
        dangerous = true;
        description = "Log out of the current session";
        enabled = true;
        icon = "exit_to_app";
        name = "Logout";
      }
      {
        command = [
          "loginctl"
          "lock-session"
        ];
        dangerous = false;
        description = "Lock the current session";
        enabled = true;
        icon = "lock";
        name = "Lock";
      }
      {
        command = [
          "systemctl"
          "suspend-then-hibernate"
        ];
        dangerous = false;
        description = "Suspend then hibernate";
        enabled = true;
        icon = "bedtime";
        name = "Sleep";
      }
    ];
    dragThreshold = 50;
    enableDangerousActions = false;
    hiddenApps = [];
    maxShown = 7;
    maxWallpapers = 9;
    showOnHover = false;
    specialPrefix = "@";
    useFuzzy = {
      actions = false;
      apps = false;
      schemes = false;
      variants = false;
      wallpapers = false;
    };
    vimKeybinds = false;
  };
  lock = {
    recolourLogo = false;
  };
  notifs = {
    actionOnClick = false;
    clearThreshold = 0.3;
    defaultExpireTimeout = 5000;
    expandThreshold = 20;
    expire = false;
  };
  osd = {
    enableBrightness = true;
    enableMicrophone = false;
    enabled = true;
    hideDelay = 2000;
  };
  paths = {
    mediaGif = "root:/assets/bongocat.gif";
    sessionGif = "root:/assets/kurukuru.gif";
    wallpaperDir = "~/Pictures/Wallpapers";
  };
  services = {
    audioIncrement = 0.1;
    defaultPlayer = "Spotify";
    gpuType = "";
    maxVolume = 1;
    playerAliases = [
      {
        from = "com.github.th_ch.youtube_music";
        to = "YT Music";
      }
    ];
    smartScheme = true;
    useFahrenheit = false;
    useTwelveHourClock = false;
    visualiserBars = 45;
    weatherLocation = "";
  };
  session = {
    commands = {
      hibernate = [
        "systemctl"
        "hibernate"
      ];
      logout = [
        "loginctl"
        "terminate-user"
        ""
      ];
      reboot = [
        "systemctl"
        "reboot"
      ];
      shutdown = [
        "systemctl"
        "poweroff"
      ];
    };
    dragThreshold = 30;
    enabled = true;
    vimKeybinds = false;
  };
  sidebar = {
    dragThreshold = 80;
    enabled = true;
  };
  utilities = {
    enabled = true;
    maxToasts = 4;
    toasts = {
      audioInputChanged = true;
      audioOutputChanged = true;
      capsLockChanged = true;
      chargingChanged = true;
      configLoaded = true;
      dndChanged = true;
      gameModeChanged = true;
      kbLayoutChanged = true;
      nowPlaying = false;
      numLockChanged = true;
      vpnChanged = true;
    };
    vpn = {
      enabled = false;
      provider = [
        {
          displayName = "Wireguard (Your VPN)";
          interface = "your-connection-name";
          name = "wireguard";
        }
      ];
    };
  };
}
