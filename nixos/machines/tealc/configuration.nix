# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/desktop.nix
      ../../modules/networking.nix
      ../../modules/services.nix
      ../../modules/system.nix
    ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["zfs"];
    # tmpOnTmpfs = true;
  };

  environment.etc =
    let
      link = x: { source = "/persist/etc/${x}"; };
      files = [
        "machine-id"
        "ssh/ssh_host_rsa_key"
        "ssh/ssh_host_rsa_key.pub"
        "ssh/ssh_host_ed25519_key"
        "ssh/ssh_host_ed25519_key.pub"
      ];
    in
      pkgs.lib.genAttrs files link;

  fileSystems =
    let
      mount = x: {
        device = "/persist${x}";
        options = [ "bind" ];
      };
      dirs = [
        "var/log"
        "var/lib/systemd/coredump"
      ];
    in
      pkgs.lib.genAttrs (map (x: "/${x}") dirs) mount // {
        "/etc/nixos" = mount "/dot-files/nixos";
      };


  networking = {
    hostId = "ec76af14";
    hostName = "tealc";
    firewall.enable = false;

    # defaultGateway = "172.16.141.1";
    # nameservers = ["172.16.141.1"];
    interfaces.ens33 = {
      useDHCP = true;
      # useDHCP = false;
      # ipv4.addresses = [
      #   {
      #     address = "172.16.141.20";
      #     prefixLength = 24;
      #   }
      # ];
    };
    useDHCP = false;
  };

  nix = {
  # package = pkgs.nixUnstable;
  # extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';

  # maxJobs = pkgs.lib.mkForce 4;
    buildCores = pkgs.lib.mkForce 1;
  # daemonNiceLevel = 10;
    envVars = {
      TMPDIR = "/tmp2";
    };
  };

  users = {
    mutableUsers = false;
    users = {
      root.initialHashedPassword = "$6$gdpMMTVeVitX0$jbXCRI/yWr6AzsL2K2VyPvNApb0xb8iipCkv2SPCALf3dz9vRjKlPRUFVWgd2OOA7ZJeRs8sFSNL0rd072fHG.";
      rwallace.initialHashedPassword = "$6$caUyXsJ6$YqTfq2glYOMpbmONsO1iVXmmJjlOIDHNp9EATJeLApity2Bf6nAqrsoFmFS/Mb9qMLMyLNVEMMHVGJk4Zx4Bp.";
    };
  };

  virtualisation = {
    vmware.guest = {
      enable = true;
      headless = false;
    };
  };

  system.stateVersion = "20.09";
}
