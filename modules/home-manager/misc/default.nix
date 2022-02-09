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
        github-w = {
          host = "github-w";
          hostname = "github.com";
          identityFile = "~/.ssh/id_ed25519_w";
          identitiesOnly = true;
        };

        jumpbox = {
          host = "jumpbox";
          hostname = "ec2-54-177-68-232.us-west-1.compute.amazonaws.com";
        };

        intusurg = {
          host = "intusurg";
          hostname = "localhost";
          port = 10122;
          proxyJump = "jumpbox";
          user = "linuxdev";
          identityFile = "~/.ssh/id_ed25519_w";
        };


        intsurg-bb = {
          host = "bitbucket.corp.intusurg.com";
          proxyJump = "intusurg";
        };
      };
    };
  };
}
