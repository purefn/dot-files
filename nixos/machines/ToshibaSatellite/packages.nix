with import <nixpkgs> {};

[
  # basics
  aspell
  aspellDicts.en
  awscli
  aws-vault
  direnv
  gnupg
  lsof
  neovim
  nix-repl
  parallel
  powerline-fonts
  psmisc
  s3cmd
  tree
  unzip
  zip

  # audio
  pamixer
  paprefs
  pasystray
  pavucontrol

  # desktop
  adjust-volume
  dmenu
  fira-code
  fira-code-symbols
  gnome3.adwaita-icon-theme
  hicolor-icon-theme
  gnome3.eog
  gnome3.evince
  gnome3.file-roller
  gnome3.gnome_keyring
  gnome3.networkmanagerapplet
  gnome3.networkmanager_openconnect
  kitty
  libnotify
  notify-osd
  kitty
  # seahorse
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
  # vagrant
  wireshark

  # general dev
  cachix
  ctags
  # darcs
  gitFull
  gnumake
  ngrok

  # haskell dev
  # all-hies
  cabal-install
  nix-ghci
  # haskell-ide-engine
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
]
