{
  services = {
    # notifications
    swaync = {
      enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
        bind = [
          "$mainMod, N, exec, swaync-client -t"
        ];
      };
    };
}

