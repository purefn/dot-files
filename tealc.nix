{ config, pkgs, ... }:

{
  imports = [
    ./machines/tealc/configuration.nix
    ./modules/desktop/default.nix
  ];

  networking = {
    hostId = "ec76af14";
    hostName = "tealc";
    firewall.enable = false;

    # defaultGateway = "172.16.141.1";
    # nameservers = ["172.16.141.1"];
    interfaces.ens33 = {
      useDHCP = true;
      # useDHCP = false;
      # ipv4.addresses = [
      #   {
      #     address = "172.16.141.20";
      #     prefixLength = 24;
      #   }
      # ];
    };
    useDHCP = false;
  };
}
