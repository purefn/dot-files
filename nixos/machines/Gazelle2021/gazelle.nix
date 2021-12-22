{
  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    bluetooth.enable = true;

    # we'll just turn on the nvidia card all the time. this decreases battery life,
    # but i don't really care too much about that. it's more important to me to be
    # able to use my external monitor without having to reboot
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    system76.enableAll = true;
  };

  services.xserver = {
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = false;
        middleEmulation = true;
        tapping = true;
      };
    };

    screenSection = ''
      Option "NoLogo" "TRUE"
    '';

    videoDrivers = [ "nvidia" ];
  };
}
