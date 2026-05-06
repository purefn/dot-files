{ pkgs, ... }:

{
  # Laptop-specific user packages and configuration
  home.packages = [ pkgs.lm_sensors ];

  # Touchpad tuning. Hyprland 0.54 shifted kinetic-scroll behavior, which
  # made the default scroll_factor of 1.0 feel jumpy on this Elan touchpad.
  # Lowering it produces more events per unit of finger travel.
  wayland.windowManager.hyprland.settings.input.touchpad = {
    natural_scroll = false;
    scroll_factor = 0.4;
    disable_while_typing = true;
  };

  # Compensate for the hyprland scroll_factor in kitty so terminal scrolling
  # doesn't crawl. touch_scroll_multiplier only affects touchpad scrolling,
  # not the mouse wheel, so this is a no-op on machines without a touchpad.
  programs.kitty.settings.touch_scroll_multiplier = 2.5;
}
