{ config, pkgs, ... }:

{
  imports = [
    ../audio.nix
    ../home-manager/default.nix
    ../system.nix
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

    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DejaVuSansMono" ]; })
      # fira-code
      # fira-code-symbols
    ];
  };

  nixpkgs = {
    config.MPlayer.pulseSupport = true;

    overlays = [ (import ./overlay) ];
  };

  networking.networkmanager.enable = true;

  programs.dconf.enable = true;

  security.pam.services = {
    gnome_keyring = {
      text = ''
        auth     optional    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
        session  optional    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start

        password  optional    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
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

    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "compose:ralt";

      displayManager = {
        lightdm.enable = true;
        session = [
          {
            manage = "desktop";
            name = "home-manager";
            start = ''
              ~/.xsession-hm &
              waitPID=$!
            '';
          }
        ];
      };
    };
  };
}
