{ config, pkgs, ... }:

{
  services = {
    # keybase.enable = true;

    # kbfs = {
    #   enable = true;
    #   extraFlags = [ "-label %u" ];
    # };

    locate.enable = true;

    openssh = {
      enable = true;
      forwardX11 = true;
    };

    tailscale.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "zfs";
      autoPrune.enable = true;
    };
  };
}
