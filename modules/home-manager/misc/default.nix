{ nixos-config }:
{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      nix-prefetch-git
      sshfsFuse
    ];

    # why not authorized_keys file here? it needs to be in a directory that is not
    # readable by the world, so we have to configure at the nixos level
    file = {
      ".ssh/c-deploy.pub".source = ./ssh/c-deploy.pub;
      ".ssh/id_ed25519.pub".source = ./ssh/id_ed25519.pub;
      ".ssh/id_ed25519_w.pub".source = ./ssh/id_ed25519_w.pub;
      ".ssh/id_rsa.pub".source = ./ssh/id_rsa.pub;

      ".ssh/c-deploy".source = config.lib.file.mkOutOfStoreSymlink nixos-config.sops.secrets."ssh/c_deploy".path;
      ".ssh/id_ed25519".source = config.lib.file.mkOutOfStoreSymlink nixos-config.sops.secrets."ssh/ed".path;
      ".ssh/id_ed25519_w".source = config.lib.file.mkOutOfStoreSymlink nixos-config.sops.secrets."ssh/ed_w".path;
      ".ssh/id_rsa".source = config.lib.file.mkOutOfStoreSymlink nixos-config.sops.secrets."ssh/rsa".path;
    };
  };

  programs = {
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
