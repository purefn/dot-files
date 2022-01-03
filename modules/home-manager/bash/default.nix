{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    awscli
    aws-vault
    bpytop
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

      initExtra = ''
        # TODO have this file generated automatically
        . ${./shell_prompt.sh}
      '';

      shellAliases = {
        cat = "bat";
      };
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

    noti.enable = true;
  };
}
