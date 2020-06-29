{ pkgs, ... }:

{
  home = {
    file = {
      ".ghci".source = ./ghci;
    };
    packages = with pkgs; [
      # general dev
      cachix
      ctags
      # darcs
      gnumake
      ngrok

      # haskell dev
      # all-hies
      cabal-install
      nix-ghci
      # haskell-ide-engine
      haskellPackages.cabal2nix
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

    extraConfig = {
      core = {
        editor = "nvim";
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
    };

    ignores = [
      "*~"
      ".*.swn"
      ".*.swp"
      ".*.swo"
    ];

    lfs.enable = true;
  };

  services = {
    lorri.enable = true;
  };
}
