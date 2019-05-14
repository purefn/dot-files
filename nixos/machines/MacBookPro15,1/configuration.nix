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

  virtualisation.vmware.guest.enable = true;

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
  };

  networking = {
    hostName = "tealc";
    firewall.enable = false;
  };

  fileSystems."/home/rwallace" = {
    fsType = "nfs";
    device = "172.16.214.1:/Users/richard/home";
    options = [
      "vers=3"
    ];
  };

  virtualisation.libvirtd.enable = true;

  services = {
    nfs.server = {
      enable = true;
      exports = ''
        /portal-appliance 192.168.99.0/24(insecure,rw,sync,no_subtree_check,crossmnt,fsid=0)
        /portal-appliance/mongodb 192.168.99.0/24(insecure,rw,sync,no_subtree_check,fsid=1)
        /portal-appliance/db 192.168.99.0/24(insecure,rw,sync,no_subtree_check,no_root_squash,fsid=2)
        /portal-appliance/data 192.168.99.0/24(insecure,rw,sync,no_subtree_check,fsid=3)
        /portal-appliance/logs 192.168.99.0/24(insecure,rw,sync,no_subtree_check,fsid=4)
        /portal-appliance/backups 192.168.99.0/24(insecure,rw,sync,no_subtree_check,fsid=5)
        /portal-appliance/provisioning 192.168.99.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=6)
        /portal-appliance/seeddata 192.168.99.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=7)
        /portal-appliance/minio 192.168.99.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=8)
      '';
    };

    openvpn.servers = {
      simspace = {
        config = ''config /var/lib/vpn/Simspace-UDP-richard.wallace.conf'';
      };
    };
  };

  system.stateVersion = "19.03"; # Did you read the comment?
}
