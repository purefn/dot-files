{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };

    theme = {
      package = pkgs.gnome3.gnome-themes-extra;
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
    file = {
      ".terminfo/x/xterm-kitty".source = "${pkgs.kitty}/lib/kitty/terminfo/x/xterm-kitty";
    };

    packages = with pkgs; [
      # basics
      dmenu
      fira-code
      fira-code-symbols
      gnome3.eog
      gnome3.evince
      gnome3.file-roller
      gnome3.gnome_keyring
      gnome3.seahorse
      gnome3.zenity
      libnotify

      gnome-icon-theme
      hicolor-icon-theme

      # audio
      # pamixer
      # paprefs
      # pasystray
      # pavucontrol

      # apps
      gimp
      handbrake
      mplayer
      # mumble
      # pithos
      # steam
      transmission_remote_gtk
      # linuxPackages.virtualbox
      # vagrant
      wireshark
    ];
  };

  nixpkgs = {
    config = {
      # might be better as a program module
      MPlayer = {
        pulseSupport = true;
      };
    };

    overlays = [ (import ./overlay) ];
  };

  programs = {
    chromium.enable = true;
    firefox.enable = true;

    kitty = {
      enable = true;

      settings = {
        cursor_blink_interval = 0;
        tab_bar_edge = "top";
        tab_bar_style = "separator";
        tab_separator  = " ";
        tab_title_template  = "<{title}>";
        active_tab_background = "#f00";
        inactive_tab_background = "#000";
      };
    };
  };

  services = {
    blueman-applet.enable = true;
    cbatticon.enable = true;
    flameshot.enable = true;
    network-manager-applet.enable = true;
    pasystray.enable = true;
    status-notifier-watcher.enable = true;
    xscreensaver.enable = true;

    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };

    taffybar = {
      enable = true;
      package =
        let
          nixpkgs-2009 = pkgs.fetchgit {
            url = "https://github.com/NixOS/nixpkgs";
            rev = "e5deabe68b7f85467d2f8519efe1daabbd9a86b5";
            sha256 = "16kf2k2d9kw61lrsdm9gfs3349i77vy1xd8hjxjk5accbql5569q";
          };
        in
          (import nixpkgs-2009 {}).taffybar.override {
            packages = ps: with ps; [ hostname ];
          };
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

      extraPackages = ps: [ ps.taffybar ];
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };
  };
}
