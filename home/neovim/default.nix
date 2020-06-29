{ pkgs, ...}:

{
  # home.packages = [ pkgs.neovim ];

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    configure = {
      packages = with pkgs.vimPlugins; {
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
          vimrcs = pkgs.lib.sourceByRegex ./vimrc [ ".*\.vim$" ];
          cfgs = builtins.attrNames (builtins.readDir (vimrcs).outPath);
          exeSrc = a: "execute 'source ${vimrcs.outPath}/${a}'";
        in
          pkgs.lib.concatMapStringsSep "\n" exeSrc cfgs;
    };
  };
}
