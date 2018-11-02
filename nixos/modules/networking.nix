{ pkgs, config, ... }:

{
  networking = {
    extraHosts = ''
      192.168.1.10 seedbox
      192.168.1.11 ronin
      192.168.1.12 ronineth
      192.168.1.13 tealc
    '';
  };
}
