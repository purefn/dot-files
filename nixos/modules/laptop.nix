{ pkgs, config, ... }:

{
  services = {
    logind.lidSwitchExternalPower = "ignore";

    upower.enable = true;

    thermald.enable = true;

    xserver.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = false;
        middleEmulation = true;
        tapping = true;
      };
    };
  };
}
