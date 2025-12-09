{ pkgs, ... }:
{
  imports = [
    ../bash
    ../desktop/kitty.nix
    ../dev
    ../neovim
  ];

  home = {
    packages = with pkgs; [
      bashInteractive
      coreutils
      file
      findutils
      nix-prefetch-git
      which
    ];

    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
  };

  nix = {
    enable = true;

    package = pkgs.nix;

    settings = {
      cores = 0;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      max-jobs = "auto";
    };
  };
}
