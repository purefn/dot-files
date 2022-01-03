{ config, pkgs, ... }:

{
  imports = [
    ./machines/Precision-T3610/configuration.nix
    ./modules/desktop/default.nix
  ];

  boot = {
    tmpOnTmpfs = true;
  };

  networking = {
    hostId = "a6283497";
    hostName = "daedalus";
  };

  system.stateVersion = "21.11";
}

