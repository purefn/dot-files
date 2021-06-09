{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  nix = {
    autoOptimiseStore = true;

    distributedBuilds = false;
    trustedUsers = [ "nixBuild" "rwallace" ];

    maxJobs = "auto";
    buildCores = 0;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console.keyMap = "us";

  time.timeZone = "US/Arizona";

  environment = {
    systemPackages = with pkgs; [
      file
      gitFull
      git-crypt
      gnupg
      neovim
      pciutils
      unionfs-fuse
      which
    ];

    variables.EDITOR = pkgs.lib.mkForce "${pkgs.neovim}/bin/nvim";

    etc.timezone.text = "US/Arizona";
  };

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
    isNormalUser = true;
  };
  home-manager = {
  #   # useGlobalPkgs = true;
    users.rwallace = import /persist/dot-files/home/home.nix;
  #     let
  #       nixpkgs = { inherit (config.nixpkgs) config overlays system; };
  #     in
  #       args@{config, pkgs, ...}: (import /persist/dot-files/home/home.nix args) // { inherit nixpkgs; };
  };

  users.extraUsers.nixBuild = {
    name = "nixBuild";
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYrlyNp/qRA6EfmDvZ8x1SfvXCy/9+s7yUdEl7FTyCX nixBuild"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILb12SZhLSbRklbPmOE18Wm1+eIisqvOOc2LFnWmC7LY nixBuild"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRFLScI1Q6ul6goyJuCd+/jASAexkJ4uz5W7qdBJ/e3 nixBuild"
    ];
    isSystemUser = true;
  };

  programs.bash.enableCompletion = true;

  nixpkgs.config = {
    allowUnfree = true;
  };
}
