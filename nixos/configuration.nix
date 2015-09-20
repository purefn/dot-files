# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./audio.nix
      ./desktop.nix
      ./laptop.nix
      ./networking.nix
      ./services.nix
    ];

  nix = {
    extraOptions = "auto-optimise-store = true";
    trustedBinaryCaches = [
      "https://hydra.nixos.org"
      "http://zalora-public-nix-cache.s3-website-ap-southeast-1.amazonaws.com/"
      "http://nixpkgs-cache.s3-website-us-east-1.amazonaws.com/"
      "http://192.168.0.10:5000/"
    ];
    binaryCaches = [
      # "https://ryantrinkle.com:5443/"
      # "http://hydra.cryp.to"
      "http://nixpkgs-cache.s3-website-us-east-1.amazonaws.com/"
      "https://cache.nixos.org"
    ];
    binaryCachePublicKeys = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  environment = {
    systemPackages = with pkgs; [
      file
      gitFull
      neovim
      which # otherwise it's not available from /bin/sh
    ];

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
    
    variables.EDITOR = pkgs.lib.mkForce "nvim";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.rwallace = {
    name = "rwallace";
    group = "users";
    extraGroups = [ "audio" "disk" "libvirtd" "networkmanager" "systemd-journal" "vboxusers" "video" "wheel" ];
    uid = 1000;
    createHome = true;
    home = "/home/rwallace";
    shell = "/run/current-system/sw/bin/bash";
  };

  programs.bash.enableCompletion = true;

  time.timeZone = "US/Arizona";

  nixpkgs.config = {
    allowUnfree = true;
  };
}
