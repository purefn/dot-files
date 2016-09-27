# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/networking.nix
      ../../modules/system.nix
      ../../modules/mediaserver.nix
    ];

  # Use the gummiboot efi boot loader.
  boot = {
    kernelParams = [ "i8042.noaux" "i8042.nokdb" "i8042.nopnp" ];

    loader = {
      gummiboot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      linuxPackages = pkgs.linuxPackages_latest;
    };
  };

  networking = {
    hostName = "seedbox";
    interfaces.enp7s0f1.ip4 = [ { address = "192.168.0.10"; prefixLength = 24; } ];
    defaultGateway = "192.168.0.1";
    nameservers = [ "8.8.8.8" ];
    firewall.allowedTCPPorts = [ 22 80 9091 50500 ];
  };
}
