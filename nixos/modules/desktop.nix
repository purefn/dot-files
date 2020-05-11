{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "compose:ralt";

    displayManager = {
      lightdm.enable = true;
      defaultSession = "xinitrc";
      session = [
        {
          manage = "desktop";
          name = "xinitrc";
          start = ''
            ~/.xinitrc &
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
