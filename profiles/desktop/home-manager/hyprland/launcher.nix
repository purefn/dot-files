{
  programs = {
    # app launcher
    # TODO hyprlauncher or rofi or wofi ?
    #      * rofi and wofi are more configurable
    #      * hyprlauncher is fastest
    #      * start with hyprlauncher and see if it's "good enough"
    #      * second, try wofi since it is wayland specific
    #      * finally, try rofi
    # TODO hyprlauncher isn't available via home-manager in release-25.11, so we'll jump to rofi but should come back to hyprlaucher to try it out
    rofi = {
      enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
        "$menu" = "rofi -show drun";
        bind = [
          "$mainMod, D, exec, $menu"
        ];
    };
  };
}
