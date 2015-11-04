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
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    hostName = "seedbox";
    networkmanager.enable = false;
    firewall.allowedTCPPorts = [ 22 80 9091 ];
  };

  environment = {
    systemPackages = with pkgs; [
      pkgs.python27Packages.flexget
    ];
  };

  services = {
    transmission = {
      enable = true;
      settings = {
        rpc-whitelist = "127.0.0.1,192.168.*.*";
      };
    };

    openssh.enable = true;

    openvpn.servers.pia = {
      config = ''
        client
        dev tun100
        proto udp
        remote us-california.privateinternetaccess.com 1194
        resolv-retry infinite
        nobind
        persist-key
        persist-tun
        ca /root/.vpn/pia/ca.crt
        tls-client
        remote-cert-tls server
        auth-user-pass /root/.vpn/pia/auth.txt
        comp-lzo
        verb 1
        reneg-sec 0
        crl-verify /root/.vpn/pia/crl.pem
        dhcp-option DNS 8.8.8.8
      '';
      up = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
      down = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
    };
  };
}
