{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "compose:ralt";

    windowManager = {
      # xmonad is started in ~/.xsession
    };

    desktopManager = {
      xterm.enable = false;
    };

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
