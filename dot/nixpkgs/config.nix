{ pkgs }:
{
  allowUnfree = true;

  chromium = {
    enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash
    enablePepperPDF = true;
    enableWideVine = true;
    pulseSupport = true;
  };

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  MPlayer = {
    pulseSupport = true;
  };

  haskellPackageOverrides = with pkgs.haskell.lib; self: super: {
    hscope = dontCheck super.hscope;
    adjust-volume = self.callPackage ./adjust-volume/adjust-volume.nix {};
  };

  packageOverrides = pkgs: {
    jdk = pkgs.oraclejdk8;
    jre = pkgs.oraclejdk8;

    all = with pkgs; buildEnv {
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
        haskellPackages.adjust-volume
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
        gimp
        # gnote
        handbrake
        hipchat
        mplayer
        pithos
        # shutter
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
        (callPackage ./nix-ghci.nix {})
        haskellPackages.cabal2nix
        haskellPackages.codex
        haskellPackages.hasktags
        haskellPackages.hlint
        haskellPackages.hscope
        # haskellPackages.packunused
        haskellPackages.pandoc
        haskellPackages.pointful
        haskellPackages.pointfree

        # scala dev
        scala
        (callPackage ./sbt-extras.nix {})

        # java dev
        oraclejdk8
        maven

        # javascript dev
        haskellPackages.purescript
        jq
        nodejs
        phantomjs

        python

        mongodb-tools
      ];
    };
  };

}
