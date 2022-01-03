{ config, pkgs, ... }:

{
  imports =
    [
      ./machines/Shuttle-XPC-Slim-DH110SE/configuration.nix
      ./modules/mediaserver/default.nix
    ];

  boot.tmpOnTmpfs = true;

  networking = {
    hostId = "1f9bf057";
    hostName = "seedbox";
    interfaces = {
      enp0s31f6.ip4 = [ { address = "192.168.1.10"; prefixLength = 24; } ];

      enp3s0.useDHCP = true;
    };

    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
    # firewall.allowedTCPPorts = [ 22 80 9091 50500 ];
  };
}
