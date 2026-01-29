{
  programs = {
    # screenshots
    hyprshot = {
      enable = true;
    };
    swappy = {
      enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
        bind = [
          # Use Mod + Print to select an area, then open in swappy for editing/saving
          "$mainMod, Print, exec, hyprshot --mode region --raw | swappy -f -"
          # Use Print (alone) to screenshot the whole screen and copy to clipboard
          ", Print, exec, hyprshot --mode output --clipboard-only"
          # Use Shift + Print to screenshot active window and copy to clipboard
          "SHIFT, Print, exec, hyprshot --mode window --clipboard-only"
        ];
      };
    };
}
