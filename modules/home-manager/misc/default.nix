{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nix-prefetch-git
    sshfsFuse
  ];

  programs = {
    gpg.enable = true;

    ssh = {
      enable = true;

      compression = true;

      extraConfig = ''
        ForwardX11 = yes
      '';

      matchBlocks = {
        "tealc" = {
          user = "rwallace";
          hostname = "172.16.18.128";
          proxyJump = "tealc-osx";
        };

        "tealc-osx" = {
          user = "richard";
          hostname = "192.168.1.97";
        };
      };
    };
  };

  services = {
    gpg-agent.enable = true;
  };
}
