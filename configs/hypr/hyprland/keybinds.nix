{
  config,
  pkgs,
  ...
}: let
  caelestia = "${config.programs.caelestia.cli.package}/bin/caelestia";
  app2unit = "${pkgs.app2unit}/bin/app2unit";
  hyprpicker = "${pkgs.hyprpicker}/bin/hyprpicker";
  ydotool = "${pkgs.ydotool}/bin/ydotool";
in {
  # Submaps must be placed first
  _1submap = {
    exec = ["hyprctl dispatch submap global"];
    submap = "global";
  };

  # Launcher binds second
  _2launcher = {
    bindi = ["Super, Super_L, global, caelestia:launcher"];

    bindin = [
      "Super, catchall, global, caelestia:launcherInterrupt"
      "Super, mouse:272, global, caelestia:launcherInterrupt"
      "Super, mouse:273, global, caelestia:launcherInterrupt"
      "Super, mouse:274, global, caelestia:launcherInterrupt"
      "Super, mouse:275, global, caelestia:launcherInterrupt"
      "Super, mouse:276, global, caelestia:launcherInterrupt"
      "Super, mouse:277, global, caelestia:launcherInterrupt"
      "Super, mouse_up, global, caelestia:launcherInterrupt"
      "Super, mouse_down, global, caelestia:launcherInterrupt"
    ];
  };

  bind = [
    "$kbSession, global, caelestia:session"
    "$kbShowPanels, global, caelestia:showall"
    "$kbLock, global, caelestia:lock"
    "$kbGoToWs, 1, exec, $wsaction workspace 1"
    "$kbGoToWs, 2, exec, $wsaction workspace 2"
    "$kbGoToWs, 3, exec, $wsaction workspace 3"
    "$kbGoToWs, 4, exec, $wsaction workspace 4"
    "$kbGoToWs, 5, exec, $wsaction workspace 5"
    "$kbGoToWs, 6, exec, $wsaction workspace 6"
    "$kbGoToWs, 7, exec, $wsaction workspace 7"
    "$kbGoToWs, 8, exec, $wsaction workspace 8"
    "$kbGoToWs, 9, exec, $wsaction workspace 9"
    "$kbGoToWs, 0, exec, $wsaction workspace 10"
    "$kbGoToWsGroup, 1, exec, $wsaction -g workspace 1"
    "$kbGoToWsGroup, 2, exec, $wsaction -g workspace 2"
    "$kbGoToWsGroup, 3, exec, $wsaction -g workspace 3"
    "$kbGoToWsGroup, 4, exec, $wsaction -g workspace 4"
    "$kbGoToWsGroup, 5, exec, $wsaction -g workspace 5"
    "$kbGoToWsGroup, 6, exec, $wsaction -g workspace 6"
    "$kbGoToWsGroup, 7, exec, $wsaction -g workspace 7"
    "$kbGoToWsGroup, 8, exec, $wsaction -g workspace 8"
    "$kbGoToWsGroup, 9, exec, $wsaction -g workspace 9"
    "$kbGoToWsGroup, 0, exec, $wsaction -g workspace 10"
    "Super, mouse_down, workspace, -1"
    "Super, mouse_up, workspace, +1"
    "$kbToggleSpecialWs, exec, ${caelestia} toggle specialws"
    "$kbMoveWinToWs, 1, exec, $wsaction movetoworkspace 1"
    "$kbMoveWinToWs, 2, exec, $wsaction movetoworkspace 2"
    "$kbMoveWinToWs, 3, exec, $wsaction movetoworkspace 3"
    "$kbMoveWinToWs, 4, exec, $wsaction movetoworkspace 4"
    "$kbMoveWinToWs, 5, exec, $wsaction movetoworkspace 5"
    "$kbMoveWinToWs, 6, exec, $wsaction movetoworkspace 6"
    "$kbMoveWinToWs, 7, exec, $wsaction movetoworkspace 7"
    "$kbMoveWinToWs, 8, exec, $wsaction movetoworkspace 8"
    "$kbMoveWinToWs, 9, exec, $wsaction movetoworkspace 9"
    "$kbMoveWinToWs, 0, exec, $wsaction movetoworkspace 10"
    "$kbMoveWinToWsGroup, 1, exec, $wsaction -g movetoworkspace 1"
    "$kbMoveWinToWsGroup, 2, exec, $wsaction -g movetoworkspace 2"
    "$kbMoveWinToWsGroup, 3, exec, $wsaction -g movetoworkspace 3"
    "$kbMoveWinToWsGroup, 4, exec, $wsaction -g movetoworkspace 4"
    "$kbMoveWinToWsGroup, 5, exec, $wsaction -g movetoworkspace 5"
    "$kbMoveWinToWsGroup, 6, exec, $wsaction -g movetoworkspace 6"
    "$kbMoveWinToWsGroup, 7, exec, $wsaction -g movetoworkspace 7"
    "$kbMoveWinToWsGroup, 8, exec, $wsaction -g movetoworkspace 8"
    "$kbMoveWinToWsGroup, 9, exec, $wsaction -g movetoworkspace 9"
    "$kbMoveWinToWsGroup, 0, exec, $wsaction -g movetoworkspace 10"
    "Super+Alt, mouse_down, movetoworkspace, -1"
    "Super+Alt, mouse_up, movetoworkspace, +1"
    "Ctrl+Super+Shift, up, movetoworkspace, special:special"
    "Ctrl+Super+Shift, down, movetoworkspace, e+0"
    "Super+Alt, S, movetoworkspace, special:special"
    "$kbToggleGroup, togglegroup"
    "$kbUngroup, moveoutofgroup"
    "Super+Shift, Comma, lockactivegroup, toggle"
    "Super, left, movefocus, l"
    "Super, right, movefocus, r"
    "Super, up, movefocus, u"
    "Super, down, movefocus, d"
    "Super+Shift, left, movewindow, l"
    "Super+Shift, right, movewindow, r"
    "Super+Shift, up, movewindow, u"
    "Super+Shift, down, movewindow, d"
    "Ctrl+Super, Backslash, centerwindow, 1"
    "Ctrl+Super+Alt, Backslash, resizeactive, exact 55% 70%"
    "$kbWindowPip, exec, ${caelestia} resizer pip"
    "$kbPinWindow, pin"
    "$kbWindowFullscreen, fullscreen, 0"
    "$kbWindowBorderedFullscreen, fullscreen, 1"
    "$kbToggleWindowFloating, togglefloating"
    "$kbCloseWindow, killactive"
    "$kbSystemMonitor, exec, ${caelestia} toggle sysmon"
    "$kbMusic, exec, ${caelestia} toggle music"
    "$kbCommunication, exec, ${caelestia} toggle communication"
    "$kbTodo, exec, ${caelestia} toggle todo"
    "$kbTerminal, exec, ${app2unit} -- $terminal"
    "$kbBrowser, exec, ${app2unit} -- $browser"
    "$kbEditor, exec, ${app2unit} -- $editor"
    "Super, G, exec, ${app2unit} -- github-desktop"
    "$kbFileExplorer, exec, ${app2unit} -- $fileExplorer"
    "Super+Alt, E, exec, ${app2unit} -- nemo"
    "Ctrl+Alt, Escape, exec, ${app2unit} -- qps"
    "Ctrl+Alt, V, exec, ${app2unit} -- pavucontrol"
    "Super+Shift, S, global, caelestia:screenshotFreeze"
    "Super+Shift+Alt, S, global, caelestia:screenshot"
    "Super+Alt, R, exec, ${caelestia} record -s"
    "Ctrl+Alt, R, exec, ${caelestia} record"
    "Super+Shift+Alt, R, exec, ${caelestia} record -r"
    "Super+Shift, C, exec, ${hyprpicker} -a"
    "Super+Shift, L, exec, systemctl suspend-then-hibernate"
    "Super, V, exec, pkill fuzzel || ${caelestia} clipboard"
    "Super+Alt, V, exec, pkill fuzzel || ${caelestia} clipboard -d"
    "Super, Period, exec, pkill fuzzel || ${caelestia} emoji -p"
  ];

  bindl = [
    ", Print, exec, ${caelestia} screenshot"
    "$kbClearNotifs, global, caelestia:clearNotifs"
    "$kbRestoreLock, exec, systemctl --user start caelestia"
    "$kbRestoreLock, global, caelestia:lock"
    ", XF86MonBrightnessUp, global, caelestia:brightnessUp"
    ", XF86MonBrightnessDown, global, caelestia:brightnessDown"
    "Ctrl+Super, Space, global, caelestia:mediaToggle"
    ", XF86AudioPlay, global, caelestia:mediaToggle"
    ", XF86AudioPause, global, caelestia:mediaToggle"
    "Ctrl+Super, Equal, global, caelestia:mediaNext"
    ", XF86AudioNext, global, caelestia:mediaNext"
    "Ctrl+Super, Minus, global, caelestia:mediaPrev"
    ", XF86AudioPrev, global, caelestia:mediaPrev"
    ", XF86AudioStop, global, caelestia:mediaStop"
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    "Super+Shift, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    "Ctrl+Shift+Alt, V, exec, sleep 0.5s && ${ydotool} type -d 1 \"$(cliphist list | head -1 | cliphist decode)\""
    "Super+Alt, f12, exec, notify-send -u low -i dialog-information-symbolic 'Test notification' \"Here's a really long message to test truncation and wrapping\\nYou can middle click or flick this notification to dismiss it!\" -a 'Shell' -A \"Test1=I got it!\" -A \"Test2=Another action\""
  ];

  bindr = [
    "Ctrl+Super+Shift, R, exec, systemctl --user stop caelestia"
    "Ctrl+Super+Alt, R, exec, systemctl --user restart caelestia"
  ];

  binde = [
    "$kbPrevWs, workspace, -1"
    "$kbNextWs, workspace, +1"
    "Super, Page_Up, workspace, -1"
    "Super, Page_Down, workspace, +1"
    "Super+Alt, Page_Up, movetoworkspace, -1"
    "Super+Alt, Page_Down, movetoworkspace, +1"
    "Ctrl+Super+Shift, right, movetoworkspace, +1"
    "Ctrl+Super+Shift, left, movetoworkspace, -1"
    "$kbWindowGroupCycleNext, cyclenext, activewindow"
    "$kbWindowGroupCyclePrev, cyclenext, prev, activewindow"
    "Ctrl+Alt, Tab, changegroupactive, f"
    "Ctrl+Shift+Alt, Tab, changegroupactive, b"
    "Super, Minus, splitratio, -0.1"
    "Super, Equal, splitratio, 0.1"
  ];

  bindm = [
    "Super, mouse:272, movewindow"
    "$kbMoveWindow, movewindow"
    "Super, mouse:273, resizewindow"
    "$kbResizeWindow, resizewindow"
  ];

  bindle = [
    ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ $volumeStep%+"
    ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ $volumeStep%-"
  ];
}
