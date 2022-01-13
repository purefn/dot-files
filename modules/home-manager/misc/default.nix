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
      };
    };
  };

  services = {
    gpg-agent.enable = true;
  };
}
