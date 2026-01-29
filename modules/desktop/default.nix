{ config, pkgs, ... }:

{
  imports = [
    ../audio.nix
    ../home-manager/default.nix
    ../system.nix
  ];

  home-manager.users.rwallace.imports = [
    # add desktop specific home-manager config
    ./home-manager/default.nix
  ];

  fonts = {
    enableDefaultFonts = true;
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
    #
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    #     lightdm.enable = true;
    #     session = [
    #       {
    #         manage = "desktop";
    #         name = "home-manager";
    #         start = ''
    #           ~/.xsession-hm &
    #           waitPID=$!
    #         '';
    #       }
    #     ];
    #   };
    };
  };
}
