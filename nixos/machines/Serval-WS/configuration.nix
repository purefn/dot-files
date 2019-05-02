# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../cachix.nix
      ../../modules/audio.nix
      ../../modules/desktop.nix
      ../../modules/laptop.nix
      ../../modules/networking.nix
      ../../modules/services.nix
      ../../modules/system.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  services = {
    gnome3.gnome-keyring.enable = true;

    mongodb.bind_ip = "0.0.0.0";

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
    };

    xserver.videoDrivers = [ "nvidia" ];
  };

  networking = {
    hostName = "ronin";
    networkmanager.enable = true;

    firewall.enable = false;
  };

  security.pam.services = [
    { name = "gnome_keyring";
      text = ''
        auth     optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
        session  optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so auto_start

        password  optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
      '';
    }
  ];

  nix = {
    binaryCaches = [ "https://cache.nixos.org/" "https://nixcache.reflex-frp.org" "https://cache.dhall-lang.org" ];
    binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" "cache.dhall-lang.org:I9/H18WHd60olG5GsIjolp7CtepSgJmM2CsO813VTmM=" ];

    buildMachines = [
      # {
      #   hostName = "seedbox";
      #   maxJobs = 2;
      #   sshKey = "/root/.ssh/id_nixBuild";
      #   sshUser = "nixBuild";
      #   system = "x86_64-linux";
      #   speedFactor = 0.5;
      # }
      # {
      #   hostName = "tealc";
      #   maxJobs = 8;
      #   sshKey = "/root/.ssh/id_nixBuild";
      #   sshUser = "nixBuild";
      #   system = "x86_64-linux";
      #   speedFactor = 0.75;
      # }
    ];
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
    #   linuxPackages = pkgs.linuxPackages_latest;
    # virtualbox = pkgs.virtualbox.override { enableExtensionPack = true; };
    };
  };

  # systemd.services."fix-alx" = {
  #   description = "Make the Atheros NIC driver work for the e2400";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  #   script = "echo 1969 e0a1 > /sys/bus/pci/drivers/alx/new_id || true";
  # };
}
