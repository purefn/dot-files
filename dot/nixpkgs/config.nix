{
  allowUnfree = true;

  chromium = {
    enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash
    enablePepperPDF = true;
    pulseSupport = true;
  };

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  MPlayer = {
    pulseSupport = true;
  };

  packageOverrides = pkgs: {
    jdk = pkgs.openjdk8;
    jre = pkgs.openjdk8;

    all = with pkgs; buildEnv {
      name = "all";
      paths = [
        # basics
        aspell
        aspellDicts.en
        gnupg
        neovim
        nix-repl
        nox
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
        libnotify
        notify-osd
        rxvt_unicode-with-plugins
        taffybar
        xbindkeys
        xcompmgr
        (xmonad-with-packages.override {
          ghcWithPackages = haskellPackages.ghcWithPackages;
          packages = hpkgs: [
            hpkgs.xmonad-contrib
            hpkgs.xmonad-extras
            hpkgs.taffybar
          ];
        })
        xscreensaver

        # browsers
        chromium
        firefox

        # apps
        deluge
        gimp
        # gnote
        handbrake
        hipchat
        mplayer
        pithos
        # shutter
        sshfsFuse
        steam
        wireshark

        # general dev
        ctags
        darcs
        gitFull
        gnumake
        ngrok

        # haskell dev
        haskellPackages.cabal2nix
        haskellPackages.codex
        haskellPackages.hasktags
        haskellPackages.hlint
        haskellPackages.hscope
        haskellPackages.packunused
        haskellPackages.pandoc
        haskellPackages.pointful
        haskellPackages.pointfree

        # scala dev
        scala
        sbt

        # java dev
        jdk
        maven

        # javascript dev
        haskellPackages.purescript
        nodejs
      ];
    };
  };

}
