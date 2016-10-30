{ pkgs, config, ... }:

{
  networking = {
    extraHosts = ''
      192.168.0.10 seedbox
    '';
  };
}
