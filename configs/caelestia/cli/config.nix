{
  config,
  pkgs,
  dots,
  use,
  ...
}: {
  record = {
    extraArgs = [];
  };

  theme = {
    enableTerm = true;
    enableHypr = dots.hypr.enable;
    enableDiscord = true;
    enableSpicetify = true;
    enableFuzzel = true;
    enableBtop = dots.btop.enable;
    enableGtk = true;
    enableQt = true;
  };

  toggles = {
    communication = {
      discord = {
        enable = true;
        match = [{class = "discord";}];
        command = ["discord"];
        move = true;
      };
      whatsapp = {
        enable = true;
        match = [{class = "whatsapp";}];
        move = true;
      };
    };

    music = {
      spotify = {
        enable = true;
        match = [
          {class = "Spotify";}
          {initialTitle = "Spotify";}
          {initialTitle = "Spotify Free";}
        ];
        command = ["spicetify" "watch" "-s"];
        move = true;
      };
      feishin = {
        enable = true;
        match = [{class = "feishin";}];
        move = true;
      };
    };

    sysmon = {
      btop = {
        enable = true;
        match = [
          {
            class = "btop";
            title = "btop";
            workspace = {name = "special:sysmon";};
          }
        ];
        command = ["${use "hypr.variables" "terminal" "foot"}" "-a" "btop" "-T" "btop" "fish" "-C" "exec btop"];
      };
    };

    todo = {
      todoist = {
        enable = true;
        match = [{class = "Todoist";}];
        command = ["todoist"];
        move = true;
      };
    };
  };
}
