{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    awscli
    aws-vault
    btop
    jless
    lsof
    parallel
    #powerline-fonts
    psmisc
    ripgrep
    s3cmd
    tree
    unzip
    zip
  ];

  programs = {
    bat.enable = true;

    bash = {
      enable = true;

      historyControl = [ "ignoredups" "ignorespace" ];

      # initExtra = ''
      #   # TODO have this file generated automatically
      #   . ${./shell_prompt.sh}
      # '';

      shellAliases = {
        cat = "bat";
      };

      shellOptions = [
        "direxpand"
      ];
    };

    dircolors.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    jq.enable = true;

    lesspipe.enable = true;

    lsd = {
      enable = true;
      enableAliases = true;
    };

    mcfly = {
      enable = true;
      keyScheme = "vim";
    };

    noti.enable = true;

    starship = {
      enable = true;
      settings = {
        java.disabled = true;
        nodejs.disabled = true;
        scala.disabled = true;
      };
    };
  };
}
