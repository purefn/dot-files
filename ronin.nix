{ config, pkgs, ... }:

{
  imports = [
    ./machines/Gazelle2021/configuration.nix
    ./modules/laptop.nix
  ];

  boot = {
    tmpOnTmpfs = true;
  };

  networking = {
    hostId = "06f0d967";
    hostName = "ronin";

    firewall.enable = false;
  };

  system.stateVersion = "21.11";
}

