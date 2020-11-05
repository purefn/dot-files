{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
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

    screenSection = ''
      Option "NoLogo" "TRUE"
    '';
  };

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig = {
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
