with import <nixpkgs> {};

[
  # basics
  aspell
  aspellDicts.en
  awscli
  direnv
  gnupg
  lsof
  neovim
  nix-repl
  parallel
  powerline-fonts
  psmisc
  s3cmd
  unzip
  zip

  # audio
  pamixer
  paprefs
  pasystray
  pavucontrol

  # desktop
  dmenu
  gnome3.adwaita-icon-theme
  gnome3.hicolor-icon-theme
  gnome3.gnome-icon-theme
  gnome3.eog
  gnome3.evince
  gnome3.file-roller
  gnome3.gnome_keyring
  gnome3.networkmanagerapplet
  gnome3.networkmanager_openconnect
  adjust-volume
  libnotify
  notify-osd
  rxvt_unicode-with-plugins
  haskellPackages.status-notifier-item
  taffybar
  xbindkeys
  xcompmgr
  xmonad
  xscreensaver

  # browsers
  chromium
  # firefox

  # apps
  gimp
  handbrake
  mplayer
  # mumble
  # pithos
  sshfsFuse
  # steam
  transmission_remote_gtk
  # linuxPackages.virtualbox
  vagrant
  wireshark

  # general dev
  ctags
  darcs
  gitFull
  gnumake
  ngrok

  # haskell dev
  cabal-install
  nix-ghci
  haskell-ide-engine
  haskellPackages.cabal2nix
  # haskellPackages.codex
  haskellPackages.ghcid
  # haskellPackages.hasktags
  haskellPackages.hlint
  # haskellPackages.hscope
  haskellPackages.hserv
  # haskellPackages.packunused
  haskellPackages.pandoc
  haskellPackages.pointful
  haskellPackages.pointfree

  # javascript dev
  jq

  mongodb-tools

  # atlassian packages
  cloudtoken
  stride
  laas-cli
  micros-cli
]
