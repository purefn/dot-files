# disable things that don't make sense when running
# as a VM guest

{ lib, ... }:

with lib;

{
  programs = {
    git = {
      userEmail = mkForce "richard.wallace@simspace.com";
    };

    ssh = {
      matchBlocks = mkForce {
        # "* !192.168.99.* !172.16.18.* !tealc-osx" = {
          # proxyJump = "richard@172.16.18.1";
        # };

        # "tealc-osx" = {
          # user = "richard";
          # hostname = "172.16.18.1";
        # };

        "jenkins-pipeline-node-*" = {
          user = "simspace";
          identityFile = "~/.ssh/simspace_template.key";
        };

        "qa-portal.simspace.lan" = {
          user = "simadmin";
          identityFile = "~/.ssh/simspace-portal.key";
          port = 6000;
        };
      };
    };
  };

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
