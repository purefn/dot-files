{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    bluetooth.enable = true;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    };

    opengl = {
      enable =true;
      driSupport32Bit = true;
    };
  };

  networking = {
    hostId = "a6283497";
    hostName = "daedalus";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}

