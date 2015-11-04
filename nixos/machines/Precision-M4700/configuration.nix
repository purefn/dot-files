# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./machines/dell-laptop/hardware-configuration.nix
      ./modules/audio.nix
      ./modules/desktop.nix
      ./modules/laptop.nix
      ./modules/networking.nix
      ./modules/services.nix
      ./modules/system.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    hostName = "tealc";
    networkmanager.enable = true;
  };
}
