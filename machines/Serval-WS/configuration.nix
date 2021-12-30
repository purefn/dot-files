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
    # kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    tmpOnTmpfs = true;
  };

  hardware = {
    opengl.driSupport32Bit = true;
    bluetooth.enable = true;
  };

  services = {
    blueman.enable = true;

    gnome3.gnome-keyring.enable = true;

    mongodb.bind_ip = "0.0.0.0";

    nix-serve = {
      enable = true;
      port = 5555;
      secretKeyFile = "/var/nix/nix-serve/priv.key";
    };

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
    };

    xserver.videoDrivers = [ "nvidia" ];
  };

  # fix for broken nvidia driver build https://github.com/NixOS/nixpkgs/issues/90459#issuecomment-647041204
  nixpkgs.overlays = [
    (self: super: {
      linuxPackages_latest = super.linuxPackages_latest.extend (self: super: {
        nvidiaPackages = super.nvidiaPackages // {
          stable = super.nvidiaPackages.stable.overrideAttrs (attrs: {
            patches = [
              (pkgs.fetchpatch {
                name = "nvidia-kernel-5.7.patch";
                url = "https://gitlab.com/snippets/1965550/raw";
                sha256 = "03iwxhkajk65phc0h5j7v4gr4fjj6mhxdn04pa57am5qax8i2g9w";
              })
            ];

            passthru = {
              settings = pkgs.callPackage (import <nixpkgs/pkgs/os-specific/linux/nvidia-x11/settings.nix> self.nvidiaPackages.stable "15psxvd65wi6hmxmd2vvsp2v0m07axw613hb355nh15r1dpkr3ma") {
                withGtk2 = true;
                withGtk3 = false;
              };

              persistenced = pkgs.lib.mapNullable (hash: pkgs.callPackage (import <nixpkgs/pkgs/os-specific/linux/nvidia-x11/persistenced.nix> self.nvidiaPackages.stable hash) { }) "13izz9p2kg9g38gf57g3s2sw7wshp1i9m5pzljh9v82c4c22x1fw";
            };
          });
        };
      });
    })
  ];

  networking = {
    hostName = "ronin";
    networkmanager.enable = true;

    firewall.enable = false;
  };

  security.pam.services = {
    gnome_keyring = {
      text = ''
        auth     optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
        session  optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so auto_start

        password  optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
      '';
    };
  };

  nix = {
    trustedUsers = ["rwallace"];
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
