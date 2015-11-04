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

  # Use the gummiboot efi boot loader.
  boot = {
    kernelParams = [ "i8042.noaux" "i8042.nokdb" "i8042.nopnp" ];

    loader = {
      gummiboot.enable = true;
      efi.canTouchEfiVariables = true;
    };
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

  powerManagement.enable = false;

  services = {
    mediatomb = {
      enable = true;
      ps3Support = true;
      transcoding = true;
      port = 50500;
      interface = "enp7s0f1";
    };

    xserver.videoDrivers = [ "nvidiaLegacy340" ];
  };
}
