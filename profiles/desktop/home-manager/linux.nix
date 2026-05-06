{ config, pkgs, ... }:

{
  imports = [
    ./gtk.nix
    ./hyprland/default.nix
  ];

  home = {
    packages = with pkgs; [
      # basics
      fira-code
      fira-code-symbols
      eog
      evince
      file-roller
      gnome-keyring
      networkmanagerapplet
      networkmanager-openconnect
      seahorse
      zenity
      libnotify

      adwaita-icon-theme
      papirus-icon-theme
      gnome-icon-theme
      hicolor-icon-theme

      # audio
      # adjust-volume
      # pamixer
      # paprefs
      # pasystray
      # pavucontrol

      # apps
      discord
      gimp
      handbrake
      mplayer
      # mumble
      # pithos
      # steam
      transmission-remote-gtk
      # linuxPackages.virtualbox
      # vagrant
      wireshark
    ];
  };

  programs = {
    chromium.enable = true;
    firefox.configPath = ".mozilla/firefox";
    # firefox.enable = true;

    rofi.enable = true;

    waybar.enable = true;
  };

  services = {
    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
  };

  wayland.windowManager.hyprland.enable = true;
}
