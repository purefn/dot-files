{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["zfs"];
  };

  virtualisation = {
    vmware.guest = {
      enable = true;
      headless = false;
    };
  };

  system.stateVersion = "20.09";
}
