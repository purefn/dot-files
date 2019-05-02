# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../cachix.nix
      ../../modules/networking.nix
      ../../modules/services.nix
      ../../modules/system.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };

    initrd.checkJournalingFS = false;
    kernelParams = [ "nomodeset" ];
  };

  networking.hostName = "tealc";

  system.stateVersion = "19.03"; # Did you read the comment?
}
