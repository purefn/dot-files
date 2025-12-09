{ lib, ... }:

with lib;

{
  imports = [ ../desktop ];
  services = {
    cbatticon.enable = mkForce false;
    # network-manager-applet.enable = mkForce false;
  };
}
