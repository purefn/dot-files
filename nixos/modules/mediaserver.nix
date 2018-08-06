{ config, pkgs, ... }:

{
  powerManagement.enable = false;

  environment.systemPackages = with pkgs; [ libtorrent unrar python27Packages.rarfile ];

  services = {
    flexget = {
      enable = true;
      user = "transmission";
      homeDir = "/var/lib/flexget";
      systemScheduler = false;
      config = ''
        variables: ${pkgs.writeText "flexget-secrets.yml" (builtins.readFile ./flexget/secrets.yml)}
        ${builtins.readFile ./flexget/config.yml}
      ''; 
    };

    mediatomb = {
      enable = true;
      ps3Support = true;
      port = 50500;
      interface = "enp7s0f1";
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
        # persist-tun
        ca ${toString ./vpn/pia/ca.crt}
        tls-client
        remote-cert-tls server
        auth-user-pass ${toString ./vpn/pia/auth.txt}
        comp-lzo
        verb 1
        reneg-sec 0
        crl-verify ${toString ./vpn/pia/crl.pem}
        dhcp-option DNS 8.8.8.8
      '';
      up = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
      down = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
    };

    transmission = {
      enable = true;
      settings = {
        rpc-whitelist = "127.0.0.1,192.168.*.*";
      };
    };
  };
}

