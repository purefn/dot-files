{ pkgs, config, ... }:

{
  networking = {
    extraHosts = ''
      192.168.0.10 ronin
      192.168.0.4 tealc
      68.3.236.160 habitat
    '';
    networkmanager.enable = true;
  };
}
