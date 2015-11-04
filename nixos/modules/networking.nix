{ pkgs, config, ... }:

{
  networking = {
    extraHosts = ''
      192.168.0.10 ronin
      192.168.0.11 tealc
      192.168.0.12 seedbox
      68.3.236.160 habitat
    '';
  };
}
