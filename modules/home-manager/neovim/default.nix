{ pkgs, ...}:

let
  cocSettings = {
    "diagnostic.maxWindowHeight" = 60;
    "diagnostic.virtualText" = true;
    "diagnostic.virtualTextCurrentLineOnly" = false;
    "codeLens.enable" = true;
    languageserver = {
      nix = {
        command = "rnix-lsp";
        filetypes = [ "nix" ];
      };
      haskell = {
        command = "haskell-language-server";
        args = [ "--lsp" "-d" "-l" "/tmp/LanguageServer.log" ];
        rootPatterns = [ ".hie-bios" "cabal.project" ];
        filetypes = [ "hs" "lhs" "haskell" ];
        # make sure haskell-language-server is compiled with -fbrittany
        # settings.languageServerHaskell.formattingProvider = "brittany";
        initializationOptions.haskell.formattingProvider = "brittany";
      };
      terraform = {
        command = "terraform-ls";
        args = [ "serve" ];
        filetypes = [ "terraform" "tf" ];
      };
    };
    explorer.icon.enableNerdfont = true;
    explorer.file.child.template =
      "[git | 2] [selection | clip | 1] [indent][icon | 1] [diagnosticError & 1][diagnosticWarning & 1][filename omitCenter 1][modified][readonly] [linkIcon & 1][link growRight 1 omitCenter 5][size]";
  };

  preamble =
    let vimrcs = pkgs.lib.sourceByRegex ./vimrc [ ".*\.vim$" ];
      cfgs = builtins.attrNames (builtins.readDir (vimrcs).outPath);
      exeSrc = a: "execute 'source ${vimrcs.outPath}/${a}'";
    in
      pkgs.lib.concatMapStringsSep "\n" exeSrc cfgs + "\n\n";

  p_ = plugin: { inherit plugin; config = ""; };
in {
  home.packages = with pkgs; [
    nodejs # for coc-nvim
    terraform-ls
    rnix-lsp
  ];

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
      # {
      #   plugin = ctrlp-vim;
      #   config = ''
      #     " Fuzzy find files
      #     nnoremap <silent> <Leader><space> :CtrlP<CR>
      #     let g:ctrlp_max_files=0
      #     let g:ctrlp_show_hidden=1
      #     let g:ctrlp_custom_ignore = { 'dir': '\v[\/](.git|.cabal-sandbox|.stack-work)$' }

      #     " fuzzy find buffers
      #     noremap <leader>b<space> :CtrlPBuffer<cr>
      #   '';
      # }
      # {
      #   plugin = deoplete-nvim;
      #   config = ''
      #     let g:deoplete#enable_at_startup = 1
      #   '';
      # }

      {
        plugin = coc-highlight;
        config = ''
          ${preamble}
          nmap <space>e :CocCommand explorer --no-toggle<CR>
        '';
      }
      # {
      #   plugin = coc-git;
      #   config = ''
      #     nmap <silent> gs :Gstatus<CR>
      #     nmap <silent> gu :CocCommand git.chunkUndo<CR>
      #     nmap <silent> gi :CocCommand git.chunkInfo<CR>
      #     nmap <silent> ga :CocCommand git.chunkStage<CR>
      #     nmap <silent> gb :CocCommand git.showCommit<CR>
      #     nmap <silent> gc :CocCommand git.showCommit<CR>
      #   '';
      # }
      (p_ coc-json)
      (p_ coc-html)
      # LSP support, see `cocSettings` above for lang config
      {
        plugin = coc-nvim;
        # config taken from coc.nvim readme
        config =
          let
            older = pkgs.lib.versionOlder coc-nvim.version "2022-09-07";
            compat = {
              tab = if older
                then ''pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()''
                else ''coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()'';
              s-tab = if older
                then ''pumvisible() ? "\<C-p>" : "\<C-h>"''
                else ''coc#pum#visible() ? coc#pum#prev(1)"} : "\<C-h>"'';
              cr = if older
                then ''pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"''
                else ''coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"'';
              checkBackspaceFuncDecl = if older
                then "function! s:check_back_space() abort"
                else "function! CheckBackspace() abort";
              showDocumentation = if older
                then "<SID>show_documentation()<CR>"
                else "ShowDocumentation()<CR>";
              formatCocAction = "CocAction" + pkgs.lib.optionalString (!older) "Async";
            };
          in ''
            " Some servers have issues with backup files, see #649.
            set nobackup
            set nowritebackup

            " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
            " delays and poor user experience.
            set updatetime=300

            " Always show the signcolumn, otherwise it would shift the text each time
            " diagnostics appear/become resolved.
            set signcolumn=yes

            " Use tab for trigger completion with characters ahead and navigate.
            " NOTE: There's always complete item selected by default, you may want to enable
            " no select by `"suggest.noselect": true` in your configuration file.
            " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
            " other plugin before putting this into your config.
            inoremap <silent><expr> <TAB> ${compat.tab}
            inoremap <expr><S-TAB> ${compat.s-tab}

            " Make <CR> to accept selected completion item or notify coc.nvim to format
            " <C-g>u breaks current undo, please make your own choice.
            inoremap <silent><expr> <CR> ${compat.cr}

            ${compat.checkBackspaceFuncDecl}
              let col = col('.') - 1
              return !col || getline('.')[col - 1]  =~# '\s'
            endfunction

            " Use <c-space> to trigger completion.
            if has('nvim')
              inoremap <silent><expr> <c-space> coc#refresh()
            else
              inoremap <silent><expr> <c-@> coc#refresh()
            endif

            " Use `[g` and `]g` to navigate diagnostics
            " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
            nmap <silent> [g <Plug>(coc-diagnostic-prev)
            nmap <silent> ]g <Plug>(coc-diagnostic-next)

            " GoTo code navigation.
            nmap <silent> gd <Plug>(coc-definition)
            nmap <silent> gy <Plug>(coc-type-definition)
            nmap <silent> gi <Plug>(coc-implementation)
            nmap <silent> gr <Plug>(coc-references)

            " Use K to show documentation in preview window.
            nnoremap <silent> K :call ${compat.showDocumentation}

            function! ShowDocumentation()
              if CocAction('hasProvider', 'hover')
                call CocActionAsync('doHover')
              else
                call feedkeys('K', 'in')
              endif
            endfunction

            function! s:show_documentation()
              if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
              elseif (coc#rpc#ready())
                  call CocActionAsync('doHover')
              else
                execute '!' . &keywordprg . " " . expand('<cword>')
              endif
            endfunction

            " Highlight the symbol and its references when holding the cursor.
            autocmd CursorHold * silent call CocActionAsync('highlight')

            " Symbol renaming.
            nmap <leader>rn <Plug>(coc-rename)

            " Formatting selected code.
            xmap <leader>f  <Plug>(coc-format-selected)
            nmap <leader>f  <Plug>(coc-format-selected)

            augroup mygroup
              autocmd!
              " Setup formatexpr specified filetype(s).
              autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
              " Update signature help on jump placeholder.
              autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
            augroup end

            " Applying codeAction to the selected region.
            " Example: `<leader>aap` for current paragraph
            xmap <leader>a  <Plug>(coc-codeaction-selected)
            nmap <leader>a  <Plug>(coc-codeaction-selected)

            " Remap keys for applying codeAction to the current buffer.
            nmap <leader>ac  <Plug>(coc-codeaction)
            " Apply AutoFix to problem on the current line.
            nmap <leader>qf  <Plug>(coc-fix-current)

            " Run the Code Lens action on the current line.
            nmap <leader>cl  <Plug>(coc-codelens-action)

            " Map function and class text objects
            " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
            xmap if <Plug>(coc-funcobj-i)
            omap if <Plug>(coc-funcobj-i)
            xmap af <Plug>(coc-funcobj-a)
            omap af <Plug>(coc-funcobj-a)
            xmap ic <Plug>(coc-classobj-i)
            omap ic <Plug>(coc-classobj-i)
            xmap ac <Plug>(coc-classobj-a)
            omap ac <Plug>(coc-classobj-a)

            " Remap <C-f> and <C-b> for scroll float windows/popups.
            if has('nvim-0.4.0') || has('patch-8.2.0750')
              nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
              nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
              inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
              inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
              vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
              vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            endif

            " Use CTRL-S for selections ranges.
            " Requires 'textDocument/selectionRange' support of language server.
            nmap <silent> <C-s> <Plug>(coc-range-select)
            xmap <silent> <C-s> <Plug>(coc-range-select)

            " Add `:Format` command to format current buffer.
            command! -nargs=0 Format :call ${compat.formatCocAction}('format')

            " Add `:Fold` command to fold current buffer.
            command! -nargs=? Fold :call     CocAction('fold', <f-args>)

            " Add `:OR` command for organize imports of the current buffer.
            command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

            " Add (Neo)Vim's native statusline support.
            " NOTE: Please see `:h coc-status` for integrations with external plugins that
            " provide custom statusline: lightline.vim, vim-airline.
            set statusline^=%{coc#status()}%{get(b:,'coc_current_function',''')}

            " Mappings for CoCList
            " Show all diagnostics.
            nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
            " Manage extensions.
            nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
            " Show commands.
            nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
            " Find symbol of current document.
            nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
            " Search workspace symbols.
            nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
            " Do default action for next item.
            nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
            " Do default action for previous item.
            nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
            " Resume latest coc list.
            nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
          '';
      }
      (p_ coc-yaml)

      (p_ dhall-vim)

      # git commands
      (p_ fugitive)

      {
        plugin = haskell-vim;
        config = ''
          let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
          let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
          let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
          let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
          let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
          let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
          let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
        '';
      }
      {
        plugin = nerdcommenter;
        config = ''
          " Add spaces after comment delimiters by default
          let g:NERDSpaceDelims = 1

          " Use compact syntax for prettified multi-line comments
          let g:NERDCompactSexyComs = 1

          " Align line-wise comment delimiters flush left instead of following code indentation
          let g:NERDDefaultAlign = 'left'
        '';
      }
      # {
      #   plugin = LanguageClient-neovim;
      #   config = ''
      #     nnoremap <F5> :call LanguageClient_contextMenu()<CR>
      #     map <leader>lk :call LanguageClient#textDocument_hover()<CR>
      #     map <leader>lg :call LanguageClient#textDocument_definition()<CR>
      #     map <leader>lr :call LanguageClient#textDocument_rename()<CR>
      #     map <leader>lf :call LanguageClient#textDocument_formatting()<CR>
      #     map <leader>lb :call LanguageClient#textDocument_references()<CR>
      #     map <leader>la :call LanguageClient#textDocument_codeAction()<CR>
      #     map <leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

      #     hi link ALEError Error
      #     hi Warning term=underline cterm=underline ctermfg=Yellow gui=undercurl guisp=Gold
      #     hi link ALEWarning Warning
      #     hi link ALEInfo SpellCap
      #   '';
      # }
      (p_ purescript-vim)
      # {
      #   plugin = supertab;
      #   config = ''
      #     " Use buffer words as default tab completion
      #     let g:SuperTabDefaultCompletionType = '<c-x><c-p>'
      #   '';
      # }
      # {
      #   plugin = syntastic;
      #   config = ''
      #     " disable syntastic for haskell
      #     let g:syntastic_haskell_checkers = [${"''"}]
      #   '';
      # }
      {
        plugin = vim-airline;
        config = ''
          " Use powerline fonts for airline
          if !exists('g:airline_symbols')
            let g:airline_symbols = {}
          endif

          let g:airline_powerline_fonts = 1
          let g:airline_symbols.space = "\ua0"
          let g:airline_skip_empty_sections = 1
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#nvimlsp#enabled = 0
        '';
      }
      (p_ vim-airline-themes)
      (p_ vim-hoogle)
      (p_ vim-markdown)
      (p_ vim-nix)
      (p_ vim-terraform)
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
      {
        plugin = vim-trailing-whitespace;
        config = ''
          autocmd BufWrite * :FixWhitespace
        '';
      }
    ];
  };

  xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON cocSettings;
}
