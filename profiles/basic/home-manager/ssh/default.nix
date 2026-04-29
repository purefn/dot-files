{ nixos-config }:
{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      nix-prefetch-git
      sshfs-fuse
    ];

    # why not authorized_keys file here? it needs to be in a directory that is not
    # readable by the world, so we have to configure at the nixos level
    file = {
      ".ssh/c-deploy.pub".source = ./c-deploy.pub;
      ".ssh/id_ed25519.pub".source = ./id_ed25519.pub;
      ".ssh/id_rsa.pub".source = ./id_rsa.pub;

      ".ssh/c-deploy".source = config.lib.file.mkOutOfStoreSymlink nixos-config.sops.secrets."ssh/c_deploy".path;
      ".ssh/id_ed25519".source = config.lib.file.mkOutOfStoreSymlink nixos-config.sops.secrets."ssh/ed".path;
      ".ssh/id_rsa".source = config.lib.file.mkOutOfStoreSymlink nixos-config.sops.secrets."ssh/rsa".path;
    };
  };

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        compression = true;
        forwardX11 = true;
      };

      includes = [ "${config.lib.file.mkOutOfStoreSymlink nixos-config.sops.secrets."ssh/config".path}" ];
    };
  };
}
