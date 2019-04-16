{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "compose:ralt";

    windowManager = {
      # xmonad is started in ~/.xsession
      default = "none";
    };

    desktopManager = {
      xterm.enable = false;
      default = "none";
    };

    displayManager = {
      slim = {
        enable = true;
        defaultUser = "rwallace";
        theme = pkgs.fetchurl {
          url = "https://github.com/jagajaga/nixos-slim-theme/archive/1.1.tar.gz";
          sha256 = "0cawq38l8rcgd35vpdx3i1wbs3wrkcrng1c9qch0l4qncw505hv6";
        };
      };
    };

    screenSection = ''
      Option "NoLogo" "TRUE"
    '';
  };

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      # dpi = 96;

      defaultFonts = {
        monospace = [ "Fira Code" "DejaVu Sans Mono" ];
      };
    };

    fonts = with pkgs; [
      fira-code
      fira-code-symbols
    ];
  };

  environment.systemPackages = [ pkgs.gnome3.dconf ];
}
