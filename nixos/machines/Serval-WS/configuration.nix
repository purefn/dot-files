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

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    opengl.driSupport32Bit = true;
    bluetooth.enable = true;
  };

  services = {
    blueman.enable = true;

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

    sshServe = {
      enable = true;
      keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxOCHEL+sVGfYcc0rCihM7IswfUdtovGQqrgn8k6l0uQdFwsExbw+WGyCVrUYHKtR6PrBaayFh+VWW71xHMfqIlUnBqrmPMXGi0B9lja3fbNFD3JAkEjUSKC2fIvPdWaimCgjHynw51wLA4DpkfHoZsD60dM3pTD+xVcrYKEWOqaPPXoB+XGNUFkpjk8JxkxMqVRPe1OmWkqudAGI0n3FdzSgduR6X+nBwvi8TOC70NpSo72eF6HBiati5cdS5MhCANRNTldWA8XhsZdFYcYV2MVZiM7kgEQXa54PRyrAl2rQRooY7HHMjyVcjPsmYZVwB8K/dybu9oXhMOQTmlj/v root@tealc" ];
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
