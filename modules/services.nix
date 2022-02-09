{ config, pkgs, ... }:

{
  programs = {
    ssh = {
      startAgent = true;
      enableAskPassword = true;
    };
  };
  services = {
    # keybase.enable = true;

    # kbfs = {
    #   enable = true;
    #   extraFlags = [ "-label %u" ];
    # };

    locate.enable = true;

    openssh = {
      enable = true;
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
