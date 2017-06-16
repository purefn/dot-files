{ pkgs, config, ... }:

{
  networking = {
    extraHosts = ''
      192.168.1.10 seedbox
    '';
  };
}
