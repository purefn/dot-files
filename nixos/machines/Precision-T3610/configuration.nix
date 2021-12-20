# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/audio.nix
      ../../modules/desktop.nix
      ../../modules/networking.nix
      ../../modules/services.nix
      ../../modules/system.nix
    ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_5_4;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "zfs" ];

    tmpOnTmpfs = true;
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
        "etc/NetworkManager/system-connections"
      ];
    in
      pkgs.lib.genAttrs (map (x: "/${x}") dirs) mount // {
        "/etc/nixos" = mount "/dot-files/nixos";
      };

  hardware = {
    opengl = {
      enable =true;
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    };
  };

  networking = {
    hostId = "a6283497";
    hostName = "daedalus";
    networkmanager.enable = true;
    # wireless.enable = true;
    firewall.allowedTCPPorts = [ 3389 ];
  };

  # nix = {
  #   package = pkgs.nixUnstable;
  #   extraOptions = ''
  #     experimental-features = nix-command flakes
  #   '';
  # };

  powerManagement.enable = false;

  security.pam.services = {
    gnome_keyring = {
      text = ''
        auth     optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
        session  optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so auto_start

        password  optional    ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
      '';
    };
  };

  services = {
    blueman.enable = true;

    gnome.gnome-keyring.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
    };

    xserver.videoDrivers = [ "nvidia" ];

    xrdp = {
      enable = true;
      # defaultWindowManager = "";
    };
  };

  users = {
    mutableUsers = false;
    users = {
      root.initialHashedPassword = "$6$gdpMMTVeVitX0$jbXCRI/yWr6AzsL2K2VyPvNApb0xb8iipCkv2SPCALf3dz9vRjKlPRUFVWgd2OOA7ZJeRs8sFSNL0rd072fHG.";
      rwallace.initialHashedPassword = "$6$caUyXsJ6$YqTfq2glYOMpbmONsO1iVXmmJjlOIDHNp9EATJeLApity2Bf6nAqrsoFmFS/Mb9qMLMyLNVEMMHVGJk4Zx4Bp.";
    };
  };

}

