{
  programs = {
    # status bar
    # TODO waybar or ashell ?
    #      * waybar is more configurable
    #      * ashell "just works"
    #      * start with ashell and see if it's "good enough"
    ashell = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };

      settings = {
        lock_cmd = "hyprlock &";
        clock.format = "%F %X";
        system_info = {
          indicators = [ "Cpu" "Memory" "Temperature" "DownloadSpeed" "UploadSpeed" ];
          temperature.sensor = "CPU temp";
        };

        modules = {
          center = [
            "WindowTitle"
          ];
          left = [
            "Workspaces"
          ];
          right = [
            "SystemInfo"
            [
              "Tray"
              "Clock"
              "Privacy"
              "Settings"
            ]
          ];
        };
      };
    };
  };
}
