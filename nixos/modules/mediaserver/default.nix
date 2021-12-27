{ config, pkgs, ... }:

{
  powerManagement.enable = false;

  environment.systemPackages = with pkgs; [ libtorrent unrar python27Packages.rarfile ];

  nixpkgs.config.packageOverrides = pkgs: {
    # radarr = pkgs.callPackage ./radarr {};
  };

  services = {
    jackett.enable = true;

    mediatomb = {
      enable = true;
      ps3Support = true;
      port = 50500;
      interface = "enp0s31f6";
    };

    openssh.enable = true;

    openvpn.servers.pia = {
      config = builtins.readFile ./vpn/pia/us_california-aes-128-cbc-udp-dns.ovpn;
      up = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
      down = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
    };

    sonarr = {
      enable = true;
      user = "transmission";
      group = "transmission";
    };

    radarr = {
      enable = true;
      user = "transmission";
      group = "transmission";
    };

    transmission = {
      enable = true;
      settings = {
        rpc-whitelist = "127.0.0.1,192.168.*.*";
        script-torrent-done-enabled = true;
        script-torrent-done-filename = pkgs.writeShellScript "transmission-done" ''
          set -eux

          TR_TORRENT_DIR=''${TR_TORRENT_DIR:-$1}
          TR_TORRENT_NAME=''${TR_TORRENT_NAME:-$2}
          TR_TORRENT_ID=''${TR_TORRENT_ID:-$3}

          ${pkgs.findutils}/bin/find "$TR_TORRENT_DIR/$TR_TORRENT_NAME" -maxdepth 1 -name "*.rar" -execdir ${pkgs.unrar}/bin/unrar e -o- "{}" \;
        '';
      };
    };
  };
}

