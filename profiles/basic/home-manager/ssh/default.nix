{ systemConfig ? null }:
{ config, pkgs, lib, ... }:

let
  hasSops = systemConfig != null;
in
{
  home = {
    packages = with pkgs; [
      nix-prefetch-git
      openssh
    ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [
      sshfs-fuse
    ];

    # why not authorized_keys file here? it needs to be in a directory that is not
    # readable by the world, so we have to configure at the nixos level
    file = lib.mkMerge [
      {
        ".ssh/c-deploy.pub".source = ./c-deploy.pub;
        ".ssh/id_ed25519.pub".source = ./id_ed25519.pub;
        ".ssh/id_rsa.pub".source = ./id_rsa.pub;
      }
      (lib.mkIf hasSops {
        ".ssh/c-deploy".source = config.lib.file.mkOutOfStoreSymlink systemConfig.sops.secrets."ssh/c_deploy".path;
        ".ssh/id_ed25519".source = config.lib.file.mkOutOfStoreSymlink systemConfig.sops.secrets."ssh/ed".path;
        ".ssh/id_rsa".source = config.lib.file.mkOutOfStoreSymlink systemConfig.sops.secrets."ssh/rsa".path;
      })
    ];
  };

  programs.ssh = lib.mkMerge [
    {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        compression = true;
        forwardX11 = true;
      };
    }
    (lib.mkIf hasSops {
      includes = [ "${config.lib.file.mkOutOfStoreSymlink systemConfig.sops.secrets."ssh/config".path}" ];
    })
  ];
}
