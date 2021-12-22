{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/audio.nix
      ../../modules/desktop.nix
      ../../modules/erase-your-darlings.nix
      ../../modules/laptop.nix
      ./gazelle.nix
      ../../modules/networking.nix
      ../../modules/services.nix
      ../../modules/system.nix
      # ../../modules/secrets.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    tmpOnTmpfs = true;
  };


  networking = {
    hostId = "06f0d967";
    hostName = "ronin";

    firewall.enable = false;
  };


  system.stateVersion = "21.11";
}

