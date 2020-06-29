{ config, pkgs, ... }:

{
  imports = [
    ./bash
    ./desktop
    ./dev
    ./misc
    ./neovim
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "rwallace";
    homeDirectory = "/home/rwallace";

    # packages = with pkgs; [
    #   # audio
    #   pamixer
    #   paprefs
    #   pasystray
    #   pavucontrol

    #   # desktop
    #   # adjust-volume
    #   dmenu
    #   fira-code
    #   fira-code-symbols
    #   gnome3.adwaita-icon-theme
    #   hicolor-icon-theme
    #   gnome3.eog
    #   gnome3.evince
    #   gnome3.file-roller
    #   gnome3.gnome_keyring
    #   gnome3.networkmanagerapplet
    #   gnome3.networkmanager_openconnect
    #   gnome3.seahorse
    #   kitty
    #   libnotify
    #   notify-osd
    #   kitty
    #   haskellPackages.status-notifier-item
    #   taffybar
    #   xbindkeys
    #   xcompmgr
    #   xmonad
    #   xscreensaver

    #   # browsers
    #   chromium
    #   # firefox

    #   # apps
    #   gimp
    #   handbrake
    #   mplayer
    #   # mumble
    #   # pithos
    #   sshfsFuse
    #   # steam
    #   transmission_remote_gtk
    #   # linuxPackages.virtualbox
    #   # vagrant
    #   wireshark

    #   # general dev
    #   cachix
    #   ctags
    #   # darcs
    #   gitFull
    #   gnumake
    #   ngrok

    #   # haskell dev
    #   # all-hies
    #   cabal-install
    #   nix-ghci
    #   # haskell-ide-engine
    #   haskellPackages.cabal2nix
    #   # haskellPackages.codex
    #   haskellPackages.ghcid
    #   # haskellPackages.hasktags
    #   haskellPackages.hlint
    #   # haskellPackages.hscope
    #   haskellPackages.hserv
    #   # haskellPackages.packunused
    #   haskellPackages.pandoc
    #   # haskellPackages.pointful
    #   # haskellPackages.pointfree

    #   # javascript dev
    #   jq
    # ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "20.09";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
