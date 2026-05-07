let 
  themeName = "catppuccin";
in {
  config.vim = {
    viAlias = true;
    vimAlias = true;
    options = {
      tabstop = 2;
      shiftwidth = 2;
    };

    spellcheck = {
      enable = true;
    };

    lsp = {
      enable = true;
      inlayHints.enable = true;
      lspkind.enable = false;
      lightbulb.enable = true;
      lspsaga.enable = false;
      trouble.enable = true;
      otter-nvim.enable = true;
      nvim-docs-view.enable = true;

      # conflicts with blink in maximal
      # lspSignature.enable = true; 
    };

    languages = {
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      bash.enable = true;
      css.enable = true;
      haskell.enable = true;
      html.enable = true;
      markdown.enable = true;
      nix.enable = true;
      sql.enable = true;
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;
    };
    
    statusline = {
      lualine = {
        enable = true;
        theme = themeName;
      };
    };

    theme = {
      enable = true;
      name = themeName;
      style = "mocha";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = true;

    autocomplete = {
      nvim-cmp.enable = false;
      blink-cmp.enable = true;
    };

    snippets.luasnip.enable = true;

    filetree.neo-tree.enable = true;

    tabline = {
      nvimBufferline.enable = true;
    };

    treesitter.context.enable = true;

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope.enable = true;

    git = {
      enable = true;
      gitsigns = {
        enable = true;
        codeActions.enable = false; # throws an annoying debug message
      };
      neogit.enable = true;
    };

    minimap = {
      minimap-vim.enable = false;
      # codewindow.nvim's highlight.lua requires nvim-treesitter.ts_utils,
      # which the upstream rewrite (nixpkgs master, 0.10.0-unstable-2026-04-03)
      # no longer ships. Disable until codewindow drops the dependency.
      codewindow.enable = false; # lighter, faster, and uses lua for configuration
    };

    dashboard = {
      dashboard-nvim.enable = false;
      alpha.enable = true;
    };

    notify = {
      nvim-notify.enable = true;
    };

    # do i care about this? i dunno probably not
    # projects = {
    #   project-nvim.enable = true;
    # };

    utility = {
      diffview-nvim.enable = true;
      icon-picker.enable = true;
      surround.enable = true;
      motion = {
        hop.enable = true;
        leap.enable = true;
        precognition.enable = true;
      };
    };

    notes = {
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };
      smartcolumn.enable = true;
      fastaction.enable = true;
    };

    session = {
      nvim-session-manager.enable = false;
    };

    comments = {
      comment-nvim.enable = true;
    };

    # assistant = {
    #   chatgpt.enable = false;
    #   copilot = {
    #     enable = false;
    #     cmp.enable = isMaximal;
    #   };
    #   codecompanion-nvim.enable = false;
    #   avante-nvim.enable = isMaximal;
    # };
  };
}
