# disable things that don't make sense when running
# as a VM guest

{ lib, ... }:

with lib;

{
  services = {
    blueman-applet.enable = mkForce false;
    cbatticon.enable = mkForce false;
    network-manager-applet.enable = mkForce false;
    pasystray.enable = mkForce false;
    xscreensaver.enable = mkForce false;

    # these may be worth it but need testing
    flameshot.enable = mkForce false;
    picom.enable = mkForce false;
  };
}
