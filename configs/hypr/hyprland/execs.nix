{
  pkgs,
  config,
  ...
}:
with pkgs; {
  # commented execs were supplied by home-manager modules
  exec-once = [
    # "gnome-keyring-daemon --start --components=secrets"
    # "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    # "wl-paste --type text --watch ${cliphist}/bin/cliphist store"
    # "wl-paste --type image --watch ${cliphist}/bin/cliphist store"
    "${trash-cli}/bin/trash-empty 30"
    "hyprctl setcursor $cursorTheme $cursorSize"
    # "gsettings set org.gnome.desktop.interface cursor-theme '$cursorTheme'"
    # "gsettings set org.gnome.desktop.interface cursor-size $cursorSize"
    # "/usr/lib/geoclue-2.0/demos/agent"
    # "sleep 1 && ${gammastep}/bin/gammastep"
    "${bluez}/bin/mpris-proxy"
    "${config.programs.caelestia.cli.package}/bin/caelestia resizer -d"
    # "caelestia shell -d"
  ];
}
