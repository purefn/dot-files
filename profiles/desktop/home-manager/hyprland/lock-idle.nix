{
  programs = {
    # lock screen
    hyprlock = {
      enable = true;
      # settings = {};
    };
  };

  services = {
    # idleness handler - turns off screen, sleeps, so on
    hypridle = {
      enable = true;
      settings = {
        listener = [
          {
            timeout = 300;                                # 5 minutes
            on-timeout = "hyprlock";                      # lock screen
          }

          {
            timeout = 600;                                # 10 minutes
            on-timeout = "hyprctl dispatch dpms off";     # turn off screen
            on-resume = "hyprctl dispatch dpms on";       # turn on screen when active
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
        bind = [
          "$mainMod, escape, exec, hyprlock"
        ];
      };
    };
}
