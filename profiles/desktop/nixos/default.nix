{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.profiles.desktop.enable {
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fontconfig = {
        defaultFonts = {
          monospace = [ "FiraCode Nerd Font" "DejaVu Sans Mono Nerd Font" ];
        };
      };

      packages =
        with pkgs.nerd-fonts; [ fira-code dejavu-sans-mono ];
    };

    nixpkgs = {
      # config.MPlayer.pulseSupport = true;

      # overlays = [ (import ./overlay) ];
    };

    networking.networkmanager.enable = true;

    programs = {
      dconf.enable = true;

      hyprland.enable = true;
    };

    security = {
      pam.services = {
        gdm-password.enableGnomeKeyring = true;
      };

      polkit.enable = true;

      # gnome_keyring = {
      #   text = ''
      #     auth     optional    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
      #     session  optional    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
      #
      #     password  optional    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
      #   '';
      # };
    };

    services = {
      # blueman.enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      gnome.gnome-keyring.enable = true;

      gvfs.enable = true;

      power-profiles-daemon.enable = true;

      # printing = {
      #   enable = true;
      #   drivers = [ pkgs.gutenprint pkgs.hplipWithPlugin ];
      # };

      xserver = {
        enable = true;
      #   layout = "us";
      #   xkbOptions = "compose:ralt";
      };
    };
  };
}
