{ config, pkgs, ... }:

{
  nix = {
    extraOptions = "auto-optimise-store = true";
    trustedBinaryCaches = [
      "https://hydra.nixos.org"
    ];
    binaryCaches = [
      "https://cache.nixos.org"
    ];
    binaryCachePublicKeys = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
  };

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "US/Arizona";

  environment = {
    systemPackages = with pkgs; [
      file
      gitFull
      git-crypt
      gnupg
      pciutils
      # neovim
      which
    ];

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

    variables.EDITOR = pkgs.lib.mkForce "nvim";

    etc.timezone.text = "US/Arizona";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.rwallace = {
    name = "rwallace";
    group = "users";
    extraGroups = [
      "audio"
      "cdrom"
      "disk"
      "docker"
      "libvirtd"
      "networkmanager"
      "systemd-journal"
      "transmission"
      "users"
      "vboxusers"
      "video"
      "wheel"
    ];
    uid = 1000;
    createHome = true;
    home = "/home/rwallace";
    shell = "/run/current-system/sw/bin/bash";
  };

  programs.bash.enableCompletion = true;

  nixpkgs.config = {
    allowUnfree = true;
  };
}
