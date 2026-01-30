{ pkgs, ... }:

{
  # Laptop-specific user packages and configuration
  home.packages = [ pkgs.lm_sensors ];

  # Could add other laptop-specific user config here
  # like battery status in prompt, power-saving aliases, etc.
}
