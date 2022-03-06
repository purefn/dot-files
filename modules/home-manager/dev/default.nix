{ pkgs, ... }:

{
  home = {
    file = {
      ".ghci".source = ./ghci;
      ".stack/config.yaml".source = ./stack.yaml;
    };
    packages = with pkgs; [
      # general dev
      cachix
      ctags
      # darcs
      gnumake
      ngrok
      binutils-unwrapped

      # haskell dev
      # all-hies
      cabal-install
      nix-ghci
      # haskell-ide-engine
      haskellPackages.cabal2nix
      haskellPackages.cabal-fmt
      # haskellPackages.codex
      haskellPackages.ghcid
      # haskellPackages.hasktags
      haskellPackages.hlint
      # haskellPackages.hscope
      haskellPackages.hserv
      # haskellPackages.packunused
      haskellPackages.pandoc
      # haskellPackages.pointful
      # haskellPackages.pointfree

      # nix
      haskellPackages.nixfmt
      niv

      # k8s
      kubectl
    ];
  };

  nixpkgs.overlays = [ (import ./overlay) ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = "Richard Wallace";
    userEmail = "rwallace@thewallacepack.net";

    aliases = {
      st = "status";
      ci = "commit";
      co = "checkout";
      br = "branch";
    };

    delta = {
      enable = true;
      options.side-by-side = true;
    };

    extraConfig = {
      checkout = {
        defaultRemote = "origin";
      };
      core = {
        editor = "nvim";
      };
      pull = {
        rebase = false;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      "mergetool \"nvim\"" = {
        cmd = "nvim -f -c \"Gdiffsplit!\" \"$MERGED\"";
      };
      merge = {
        tool = "nvim";
      };
    };

    ignores = [
      "*~"
      ".*.swn"
      ".*.swp"
      ".*.swo"
      "/worktrees"
    ];

    # lfs.enable = true;
  };
}
