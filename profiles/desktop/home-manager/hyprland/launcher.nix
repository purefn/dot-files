{
  services = {
    hyprlauncher = {
      enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
        "$menu" = "hyprlauncher";
        bind = [
          "$mainMod, D, exec, $menu"
        ];
    };
  };
}
