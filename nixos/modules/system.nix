{ config, pkgs, ... }:

{
  nix = {
    autoOptimiseStore = true;
    trustedBinaryCaches = [
      "https://hydra.nixos.org"
    ];
    binaryCaches = [
      "https://cache.nixos.org"
    ];
    binaryCachePublicKeys = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];

    distributedBuilds = true;
    trustedUsers = [ "nixBuild" ];

    maxJobs = "auto";
    # maxJobs = 1;
    buildCores = 0;
    #buildCores = 1;
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
      neovim
      which
    ];

    variables.EDITOR = pkgs.lib.mkForce "${pkgs.neovim}/bin/nvim";

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

  users.extraUsers.nixBuild = {
    name = "nixBuild";
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYrlyNp/qRA6EfmDvZ8x1SfvXCy/9+s7yUdEl7FTyCX nixBuild"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILb12SZhLSbRklbPmOE18Wm1+eIisqvOOc2LFnWmC7LY nixBuild"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRFLScI1Q6ul6goyJuCd+/jASAexkJ4uz5W7qdBJ/e3 nixBuild"
    ];
  };


  programs.bash.enableCompletion = true;

  nixpkgs.config = {
    allowUnfree = true;
  };
}
