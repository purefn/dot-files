{ config, pkgs, ... }:

{
  imports = [
    ./erase-your-darlings.nix
    ./networking.nix
    ./services.nix
    ./sops
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      cores = 0;
      max-jobs = "auto";
      substituters = [
        "https://hydra.iohk.io"
      ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
      trusted-users = [ "nixBuild" "rwallace" ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console.keyMap = "us";

  time.timeZone = "US/Arizona";

  environment = {
    systemPackages = with pkgs; [
      age
      file
      gitFull
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
    openssh.authorizedKeys.keyFiles = [
      ./home-manager/misc/ssh/id_rsa.pub
      ./home-manager/misc/ssh/id_ed25519.pub
    ];
  };

  # users.extraUsers.nixBuild = {
  #   name = "nixBuild";
  #   useDefaultShell = true;
  #   openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYrlyNp/qRA6EfmDvZ8x1SfvXCy/9+s7yUdEl7FTyCX nixBuild"
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILb12SZhLSbRklbPmOE18Wm1+eIisqvOOc2LFnWmC7LY nixBuild"
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRFLScI1Q6ul6goyJuCd+/jASAexkJ4uz5W7qdBJ/e3 nixBuild"
  #   ];
  #   isSystemUser = true;
  # };

  programs.bash = {
    enableCompletion = true;
    shellAliases = {
      nixf = "nix --extra-experimental-features flakes";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
}
