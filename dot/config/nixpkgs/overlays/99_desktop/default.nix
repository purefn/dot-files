self: super:

{
  adjust-volume = super.haskellPackages.callPackage ./adjust-volume {};

  blueman = super.blueman.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ self.libappindicator-gtk3 ];
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-appindicator" ];
  });

  # haskell-ide-engine =
  #   let
  #     src = super.fetchFromGitHub (builtins.fromJSON (builtins.readFile ./all-hies.json));
  #     all-hies = import src {};
  #   in
  #     all-hies.selection { selector = p: { inherit (p) ghc863; }; };

  # mumble = super.mumble.override { pulseSupport = true; };

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
            fzf-vim
            LanguageClient-neovim
            supertab
            syntastic
            vim-airline
            vim-airline-themes
            vim-commentary
            vim-indent-guides
            vim-pandoc
            vim-pandoc-syntax

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
  # pasystray = super.callPackage ./pasystray {};

  taffybar = super.taffybar.override {
    packages = hpkgs: [ hpkgs.hostname ];
  };

  xmonad =
    super.xmonad-with-packages.override {
      packages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
        hpkgs.taffybar
      ];
    };
}
