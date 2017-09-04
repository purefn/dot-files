{ pkgs }:
{
  allowUnfree = true;

  chromium = {
    # enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash
    enablePepperPDF = true;
    # enableWideVine = true;
    pulseSupport = true;
  };

  # firefox = {
    # enableGoogleTalkPlugin = true;
    # enableAdobeFlash = true;
  # };

  MPlayer = {
    pulseSupport = true;
  };

  haskellPackageOverrides = with pkgs.haskell.lib; self: super: {
    hscope = dontCheck super.hscope;
    adjust-volume = self.callPackage ./adjust-volume/adjust-volume.nix {};
  };

  packageOverrides = pkgs: {
    # wine = pkgs.winePackages.full.override {
      # wineRelease = "staging";
      # wineBuild = "wineWow";
    # };

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
        (neovim.override {
          extraPythonPackages = [
            # for ensime-vim
            pythonPackages.websocket_client
            pythonPackages.sexpdata
            pythonPackages.neovim
          ];
        })
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
        # (xmonad-with-packages.override {
          # ghcWithPackages = haskellPackages.ghcWithPackages;
          # packages = hpkgs: [
            # hpkgs.xmonad-contrib
            # hpkgs.xmonad-extras
            # hpkgs.taffybar
          # ];
        # })
        (let
          xmonadEnv = haskellPackages.ghcWithPackages (self: [ self.xmonad self.xmonad-contrib self.xmonad-extras self.taffybar] );
        in stdenv.mkDerivation {
          name = "xmonad-with-packages";

          nativeBuildInputs = [ makeWrapper ];

          buildCommand = ''
            makeWrapper ${xmonadEnv}/bin/xmonad $out/bin/xmonad \
              --set NIX_GHC "${xmonadEnv}/bin/ghc" \
              --set XMONAD_XMESSAGE "${xorg.xmessage}/bin/xmessage"
          '';

          # trivial derivation
          preferLocalBuild = true;
          allowSubstitutes = false;
        })
        xscreensaver

        # browsers
        chromium
        # firefox

        # apps
        gimp
        # handbrake
        hipchat
        mplayer
        (mumble.override { pulseSupport = true; })
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
        (callPackage ./nix-ghci.nix {})
        haskellPackages.cabal2nix
        # haskellPackages.codex
        haskellPackages.hasktags
        haskellPackages.hlint
        # haskellPackages.hscope
        haskellPackages.hserv
        # haskellPackages.packunused
        haskellPackages.pandoc
        haskellPackages.pointful
        haskellPackages.pointfree

        # scala dev
        # scala
        # (callPackage ./sbt-extras.nix {})

        # javascript dev
        # haskellPackages.purescript
        jq

        mongodb-tools

        (callPackage ./awscli-saml-auth.nix {})
        stride
        laas-cli
        # (callPackage ./laas-cli {})

        (callPackage ./wine {
          wineRelease = "staging";
          wineBuild = "wineWow";
        })
      ];
    };
  };

}
