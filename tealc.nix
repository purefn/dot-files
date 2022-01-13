{ config, pkgs, ... }:

{
  imports = [
    ./machines/VMware-guest/configuration.nix
    ./modules/desktop/default.nix
  ];

  nix = {
    maxJobs = pkgs.lib.mkForce 4;
    buildCores = pkgs.lib.mkForce 1;
  };

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
