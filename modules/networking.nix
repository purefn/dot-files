{ pkgs, config, ... }:

{
  networking = {
    extraHosts = ''
      192.168.1.10 seedbox
      192.168.1.11 ronin
      192.168.1.97 tealc-osx
    '';

    nat = {
      # enable so nixos containers can access the internets
      enable = true;
      internalInterfaces = ["ve-+"];
      # this needs to be set in a machine specific way
      # externalInterface = "eth0";
    };

    networkmanager.unmanaged = [ "interface-name:ve-*" ];
  };
}
