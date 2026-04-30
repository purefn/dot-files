{ config, pkgs, ... }:

{
  imports = [
    ./gtk.nix
    ./hyprland/default.nix
    ./kitty.nix
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
    firefox.configPath = ".mozilla/firefox";
    # firefox.enable = true;

    rofi.enable = true;

    waybar.enable = true;
  };

  services = {
    # betterlockscreen.enable = true;
    # blueman-applet.enable = true;
    # network-manager-applet.enable = true;
    # pasystray.enable = true;
    # status-notifier-watcher.enable = true;
    # taffybar.enable = true;
    # volnoti.enable = true;

    # notify-osd.enable = true;
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

  # xdg.configFile = {
  #   "taffybar" = {
  #     source = ./taffybar;
  #     onChange = ''
  #       # Attempt to restart taffybar if X is running
  #       if [[ -v DISPLAY ]]; then
  #         pkillVerbose=""
  #         if [[ -v VERBOSE ]]; then
  #           pkillVerbose="-e"
  #         fi
  #         $DRY_RUN_CMD ${pkgs.procps}/bin/pkill -u $USER $pkillVerbose taffybar || true
  #         unset pkillVerbose
  #       fi
  #     '';
  #   };
  # };

  wayland.windowManager.hyprland.enable = true;

  # xsession = {
    # enable = true;

    # preferStatusNotifierItems = true;

    # scriptPath = ".xsession-hm";

    # windowManager.xmonad = {
    #  enable = true;
    #  # current version of taffybar, 3.3.0, doesn't compile with ghc 9
    #  haskellPackages = pkgs.haskell.packages.ghc8107;
    #  extraPackages = ps: [ ps.taffybar ];
    #  enableContribAndExtras = true;
    #  config = ./xmonad.hs;
    #};
  # };
}
