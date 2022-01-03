# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/system.nix
      ../../modules/mediaserver/default.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmpOnTmpfs = true;
    supportedFilesystems = [ "zfs" ];

  };

  fileSystems = {
    "/storage" = {
      fsType = "zfs";
      device = "rpool/safe/storage";
    };
  };

  networking = {
    hostId = "1f9bf057";
    hostName = "seedbox";
    interfaces = {
      enp0s31f6.ip4 = [ { address = "192.168.1.10"; prefixLength = 24; } ];

      enp3s0.useDHCP = true;
    };

    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
    # firewall.allowedTCPPorts = [ 22 80 9091 50500 ];
  };

  services = {
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

