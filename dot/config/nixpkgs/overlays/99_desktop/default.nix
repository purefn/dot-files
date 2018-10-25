self: super:

{
  adjust-volume = super.haskellPackages.callPackage ./adjust-volume {};

  battery-monitor = super.callPackage ./battery-monitor {};

  # handbrake = super.handbrake.override {
  #   useFfmpeg = true;
  # };

  haskell-ide-engine =
    let
      hie-nix = super.fetchFromGitHub {
        owner = "domenkozar";
        repo = "hie-nix";
        rev = "8f04568aa8c3215f543250eb7a1acfa0cf2d24ed";
        sha256 = "06ygnywfnp6da0mcy4hq0xcvaaap1w3di2midv1w9b9miam8hdrn";
      };
    in
      (import hie-nix { pkgs = super; }).hies;

  mumble = super.mumble.override { pulseSupport = true; };

  neovim = super.neovim.override {
    vimAlias = true;
    viAlias = true;

    # for ensime - the nixpkgs packaging only has them added for python2
    extraPython3Packages = with self.python3Packages; [ sexpdata websocket_client ];

    configure = {
      packages = with super.vimPlugins; {
        basics = {
          # TODO add these?
          # * mundo
          # * nerdtree
          # * tagbar
          # * extradite
          start = [
            ctrlp-vim
            deoplete-nvim
            fugitive
            fzfWrapper
            LanguageClient-neovim
            supertab
            syntastic
            vim-airline
            vim-airline-themes
            vim-commentary
            vim-indent-guides
            vim-markdown

            vim-colorschemes
            wombat256-vim
          ];
        };

        haskell = {
        };

        nix = {
          start = [
            vim-nix
          ];
        };

        purescript = {
          start = [
            purescript-vim
          ];
        };

        scala = {
          start = [
            ensime-vim
            vim-scala
          ];
        };
      };

      customRC =
        let
          vimrcs = super.lib.sourceByRegex ./vimrc [ ".*\.vim$" ];
          cfgs = builtins.attrNames (builtins.readDir (vimrcs).outPath);
          exeSrc = a: "execute 'source ${vimrcs.outPath}/${a}'";
        in
          super.lib.concatMapStringsSep "\n" exeSrc cfgs;
    };
  };

  nix-ghci = super.callPackage ./nix-ghci {};

  # override to add appindicator support
  pasystray = super.callPackage ./pasystray {};

  haskellPackages = super.haskell.packages.ghc844;

  xmonad =
    super.xmonad-with-packages.override {
      packages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
        hpkgs.taffybar
      ];
    };
}
