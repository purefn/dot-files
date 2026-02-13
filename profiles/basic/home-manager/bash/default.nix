{ config, pkgs, inputs, ... }:

let
  # Wrap direnv-instant to use coreutils cat instead of shell alias
  # The bash hook uses `cat` which conflicts with our bat alias
  direnv-instant-wrapped = inputs.direnv-instant.packages.${pkgs.system}.default.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace hooks/bash.sh \
        --replace-fail 'cat "' '${pkgs.coreutils}/bin/cat "'
    '';
  });
in
{
  home.packages = with pkgs; [
    awscli2
    aws-vault
    bashInteractive
    btop
    jless
    lsof
    parallel
    #powerline-fonts
    ripgrep
    s3cmd
    tree
    unzip
    watch
    watchexec
    zip
  ] ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
    psmisc
  ];

  programs = {
    bat.enable = true;

    bash = {
      enable = true;

      historyControl = [ "ignoredups" "ignorespace" ];

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
      # nix-direnv.enable = true;
    };
    direnv-instant = {
      enable = true;
      package = direnv-instant-wrapped;
      settings.debug_log = "/tmp/direnv-instant.log";
    };

    jq.enable = true;

    lesspipe.enable = true;

    lsd.enable = true;

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
