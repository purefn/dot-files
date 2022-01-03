{ pkgs, ...}:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # TODO add these?
      # * mundo
      # * nerdtree
      # * tagbar
      # * extradite
      {
        plugin = ctrlp-vim;
        config = ''
          " Fuzzy find files
          nnoremap <silent> <Leader><space> :CtrlP<CR>
          let g:ctrlp_max_files=0
          let g:ctrlp_show_hidden=1
          let g:ctrlp_custom_ignore = { 'dir': '\v[\/](.git|.cabal-sandbox|.stack-work)$' }

          " fuzzy find buffers
          noremap <leader>b<space> :CtrlPBuffer<cr>
        '';
      }
      {
        plugin = deoplete-nvim;
        config = ''
          let g:deoplete#enable_at_startup = 1
        '';
      }
      fugitive
      fzfWrapper
      fzf-vim
      {
        plugin = LanguageClient-neovim;
        config = ''
          augroup LanguageClient_config
            autocmd!
            autocmd User LanguageClientStarted setlocal signcolumn=yes
            autocmd User LanguageClientStopped setlocal signcolumn=auto
          augroup END
        '';
      }
      purescript-vim
      {
        plugin = supertab;
        config = ''
          " Use buffer words as default tab completion
          let g:SuperTabDefaultCompletionType = '<c-x><c-p>'
        '';
      }
      {
        plugin = syntastic;
        config = ''
          " disable syntastic for haskell
          let g:syntastic_haskell_checkers = [${"''"}]
        '';
      }
      {
        plugin = vim-airline;
        config = ''
          " Use powerline fonts for airline
          if !exists('g:airline_symbols')
            let g:airline_symbols = {}
          endif

          let g:airline_powerline_fonts = 1
          let g:airline_symbols.space = "\ua0"
          let g:airline#extensions#tabline#enabled = 1
        '';
      }
      vim-airline-themes
      vim-colorschemes
      vim-commentary
      vim-indent-guides
      vim-nix
      vim-pandoc
      vim-pandoc-syntax
      {
        plugin = wombat256-vim;
        config = ''
          colorscheme wombat256mod

          " Adjust signscolumn to match wombat
          hi! link SignColumn LineNr

          " Match wombat colors in nerd tree
          hi Directory guifg=#8ac6f2
        '';
      }
    ];

    extraConfig =
      let
        vimrcs = pkgs.lib.sourceByRegex ./vimrc [ ".*\.vim$" ];
        cfgs = builtins.attrNames (builtins.readDir (vimrcs).outPath);
        exeSrc = a: "execute 'source ${vimrcs.outPath}/${a}'";
      in
        pkgs.lib.concatMapStringsSep "\n" exeSrc cfgs + "\n\n";
  };
}
