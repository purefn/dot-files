# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../cachix.nix
      ../../modules/desktop.nix
      ../../modules/networking.nix
      ../../modules/services.nix
      ../../modules/system.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
  };

  # nix = {
  #   binaryCaches = [ "ssh://nix-ssh@192.168.1.12" "https://cache.nixos.org/" ];
  # };

  networking = {
    hostName = "tealc";
    firewall.enable = false;

    extraHosts = ''
      192.168.39.196 portal.local minio.local minio-ova.local mattermost.local keycloak.local
    '';
  };

  fileSystems = {
    "/home/rwallace" = {
      fsType = "nfs";
      device = "172.16.18.1:/Users/richard/home";
      options = [
        "vers=3"
      ];
    };
  };

  virtualisation = {
    vmware.guest.enable = true;

    libvirtd.enable = true;

    # virtualbox.host = {
    #   enable = true;
    #   enableHardening = false;
    # };
  };

  services = {
    nfs.server = {
      enable = true;
      exports = ''
        /portal-appliance 192.168.39.0/24(insecure,rw,sync,no_subtree_check,crossmnt,fsid=0)
        /portal-appliance/mongodb 192.168.39.0/24(insecure,rw,sync,no_subtree_check,fsid=1)
        /portal-appliance/db 192.168.39.0/24(insecure,rw,sync,no_subtree_check,no_root_squash,fsid=2)
        /portal-appliance/data 192.168.39.0/24(insecure,rw,sync,no_subtree_check,fsid=3)
        /portal-appliance/logs 192.168.39.0/24(insecure,rw,sync,no_subtree_check,fsid=4)
        /portal-appliance/backups 192.168.39.0/24(insecure,rw,sync,no_subtree_check,fsid=5)
        /portal-appliance/provisioning 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=6)
        /portal-appliance/seeddata 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=7)
        /portal-appliance/minio 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=8)
        /portal-appliance/minio-ova 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=8)
      '';
    };

    openvpn.servers = {
      simspace = {
        config = ''
          config /var/lib/vpn/Simspace-UDP-richard.wallace.conf
        '';
        updateResolvConf = true;
      };
    };

    minio = {
      enable = true;
      accessKey = "minioadmin";
      secretKey = "password";
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_9_6;
    };

    mongodb = {
      enable = true;
    };
  };

  programs = {
    ssh.extraConfig = ''
      Host * !192.168.99.* !172.16.18.*
        ProxyJump richard@172.16.18.1
    '';
  };

  system.stateVersion = "19.03"; # Did you read the comment?
}
