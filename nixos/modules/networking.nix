{ pkgs, config, ... }:

{
  networking = {
    extraHosts = ''
      192.168.1.10 seedbox
      192.168.1.11 ronin-wifi
      192.168.1.12 ronin
      192.168.1.15 tealc-osx
      192.168.1.99 tealc-osx-wifi
    '';
  };
}
