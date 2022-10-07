{ config, pkgs, ... }:

{
  imports = [ ./kitty.nix ];

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita";
    };

    gtk3.extraConfig = {
      gtk-button-images = 1;
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds = 1;
      gtk-menu-images = 1;
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
  };

  home = {
    packages = with pkgs; [
      # basics
      fira-code
      fira-code-symbols
      gnome.eog
      gnome.evince
      gnome.file-roller
      gnome.gnome-keyring
      networkmanagerapplet
      networkmanager-openconnect
      gnome.seahorse
      gnome.zenity
      libnotify

      gnome.adwaita-icon-theme
      papirus-icon-theme
      gnome-icon-theme
      hicolor-icon-theme

      # audio
      adjust-volume
      pamixer
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

  # nixpkgs = {
  #   config = {
  #     # might be better as a program module
  #     MPlayer = {
  #       pulseSupport = true;
  #     };
  #   };

  #   overlays = [ (import ./overlay) ];
  # };

  programs = {
    chromium.enable = true;
    firefox.enable = true;

    rofi.enable = true;
  };

  services = {
    betterlockscreen.enable = true;
    blueman-applet.enable = true;
    flameshot.enable = true;
    network-manager-applet.enable = true;
    pasystray.enable = true;
    status-notifier-watcher.enable = true;
    taffybar.enable = true;
    volnoti.enable = true;

    notify-osd.enable = true;
    # dunst = {
    #   enable = true;
    #   iconTheme = {
    #     name = "Adwaita";
    #     package = pkgs.gnome.adwaita-icon-theme;
    #     size = "16x16";
    #   };
    #   settings = {
    #     global = {
    #       monitor = 0;
    #       geometry = "600x50-50+65";
    #       shrink = "yes";
    #       transparency = 10;
    #       padding = 16;
    #       horizontal_padding = 16;
    #       font = "JetBrainsMono Nerd Font 10";
    #       line_height = 4;
    #       format = ''<b>%s</b>\n%b'';
    #     };
    #   };
    # };

    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };

    # picom = {
    #   enable = true;
    #   blur = true;
    # };
  };

  xdg.configFile = {
    "taffybar" = {
      source = ./taffybar;
      onChange = ''
        # Attempt to restart taffybar if X is running
        if [[ -v DISPLAY ]]; then
          pkillVerbose=""
          if [[ -v VERBOSE ]]; then
            pkillVerbose="-e"
          fi
          $DRY_RUN_CMD ${pkgs.procps}/bin/pkill -u $USER $pkillVerbose taffybar || true
          unset pkillVerbose
        fi
      '';
    };
  };

  xsession = {
    enable = true;

    preferStatusNotifierItems = true;

    scriptPath = ".xsession-hm";

    windowManager.xmonad = {
      enable = true;
      # current version of taffybar, 3.3.0, doesn't compile with ghc 9
      haskellPackages = pkgs.haskell.packages.ghc8107;
      extraPackages = ps: [ ps.taffybar ];
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };
  };
}
