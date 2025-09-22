{config, ...}: {
  general = {
    lock_cmd = "${config.programs.caelestia.cli.package}/bin/caelestia shell lock lock";
    before_sleep_cmd = "loginctl lock-session";
    after_sleep_cmd = "hyprctl dispatch dpms on";
  };

  listener = [
    {
      timeout = 180;
      on-timeout = "loginctl lock-session";
    }
    {
      timeout = 300;
      on-timeout = "hyprctl dispatch dpms off";
      on-resume = "hyprctl dispatch dpms on";
    }
    {
      timeout = 600;
      on-timeout = "systemctl suspend-then-hibernate || loginctl suspend";
    }
  ];
}
