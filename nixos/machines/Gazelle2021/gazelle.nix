{ pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  environment.systemPackages = [ nvidia-offload ];

  hardware = {
    bluetooth.enable = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;

      prime = {
        # sync.enable = true;
        offload.enable = true;
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
    screenSection = ''
      Option "NoLogo" "TRUE"
    '';

    videoDrivers = [ "nvidia" ];
  };

  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia = {
        prime.offload.enable = pkgs.lib.mkForce false;
        powerManagement.enable = pkgs.lib.mkForce false;
      };
    };
  };
}
