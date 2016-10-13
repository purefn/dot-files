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
      ../../modules/laptop.nix
      ../../modules/networking.nix
      ../../modules/services.nix
      ../../modules/system.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services = {
    xserver.videoDrivers = [ "nvidia" ];
  };

  networking = {
    hostName = "ronin";
    networkmanager.enable = true;
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      linuxPackages = pkgs.linuxPackages_latest;
    };
  };

  systemd.services."fix-alx" = {
    description = "Make the Atheros NIC driver work for the e2400";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = "echo 1969 e0a1 > /sys/bus/pci/drivers/alx/new_id || true";
  };
}
