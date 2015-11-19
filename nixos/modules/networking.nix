{ pkgs, config, ... }:

{
  networking = {
    extraHosts = ''
      192.168.0.10 seedbox
      192.168.0.11 tealc
      192.168.0.27 ronin
      68.3.236.160 habitat
    '';
  };
}
