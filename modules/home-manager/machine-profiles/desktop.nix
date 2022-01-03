{ lib, ... }:

with lib;

{
  services = {
    cbatticon.enable = mkForce false;
    # network-manager-applet.enable = mkForce false;
  };
}
