self: super:

{
  adjust-volume = super.haskellPackages.callPackage ./adjust-volume {};

  mumble = super.mumble.override { pulseSupport = true; };

  neovim = super.neovim.override {
    extraPythonPackages = [
      # for ensime-vim
      super.pythonPackages.websocket_client
      super.pythonPackages.sexpdata
      super.pythonPackages.neovim
    ];
  };

  nix-ghci = super.callPackage ./nix-ghci {};

  sbt-extras = super.callPackage ./sbt-extras {};

  xmonad =
    # (xmonad-with-packages.override {
      # ghcWithPackages = haskellPackages.ghcWithPackages;
      # packages = hpkgs: [
        # hpkgs.xmonad-contrib
        # hpkgs.xmonad-extras
        # hpkgs.taffybar
      # ];
    # })
    let
      xmonadEnv = super.haskellPackages.ghcWithPackages (self: [ self.xmonad self.xmonad-contrib self.xmonad-extras self.taffybar] );
    in super.stdenv.mkDerivation {
      name = "xmonad-with-packages";

      nativeBuildInputs = [ super.makeWrapper ];

      buildCommand = ''
        makeWrapper ${xmonadEnv}/bin/xmonad $out/bin/xmonad \
          --set NIX_GHC "${xmonadEnv}/bin/ghc" \
          --set XMONAD_XMESSAGE "${super.xorg.xmessage}/bin/xmessage"
      '';

      # trivial derivation
      preferLocalBuild = true;
      allowSubstitutes = false;
    };

  all = with self; buildEnv {
    name = "all";
    paths = [
      # basics
      aspell
      aspellDicts.en
      awscli
      direnv
      gnupg
      lsof
      neovim
      nix-repl
      nox
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
      # handbrake
      hipchat
      mplayer
      mumble
      pithos
      sshfsFuse
      steam
      transmission_remote_gtk
      linuxPackages.virtualbox
      vagrant
      wireshark

      # general dev
      ctags
      darcs
      gitFull
      gnumake
      ngrok

      # haskell dev
      nix-ghci
      haskellPackages.cabal2nix
      haskellPackages.codex
      haskellPackages.hasktags
      haskellPackages.hlint
      # haskellPackages.hscope
      haskellPackages.hserv
      haskellPackages.packunused
      haskellPackages.pandoc
      haskellPackages.pointful
      haskellPackages.pointfree

      # javascript dev
      jq

      mongodb-tools

      # atlassian packages
      awscli-saml-auth
      stride
      laas-cli

      # (callPackage ./wine {
      #   wineRelease = "staging";
      #  wineBuild = "wineWow";
      # })
    ];
  };
}