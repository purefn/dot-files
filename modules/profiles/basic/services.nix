{ config, pkgs, ... }:

{
  programs = {
    ssh = {
      # startAgent = true;
      enableAskPassword = true;
    };
  };

  services = {
    locate = {
      enable = true;
      locate = pkgs.plocate;
    };

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
