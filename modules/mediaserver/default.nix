{ config, pkgs, ... }:

{
  powerManagement.enable = false;

  environment.systemPackages = with pkgs; [ libtorrent unrar ];

  nixpkgs.config.packageOverrides = pkgs: {
    # radarr = pkgs.callPackage ./radarr {};
  };

  disabledModules = [ "services/misc/mediatomb.nix" ];

  imports = [ ./mediatomb.nix ];

  services = {
    jackett.enable = true;

    mediatomb = {
      enable = true;
      ps3Support = true;
      port = 50500;
      interface = "enp0s31f6";
      mediaDirectories = [
        {
          path = "/storage/series";
          recursive = true;
          hidden-files = false;
        }
        {
          path = "/storage/movies";
          recursive = true;
          hidden-files = false;
        }
      ];
      layout = {
        parentPath = true;
      };
    };

    openssh.enable = true;

    openvpn.servers.pia = {
      config = "config /persist/etc/openvpn/pia/us_california.ovpn";
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

    tailscale.enable = true;

    transmission = {
      enable = true;
      settings = {
        download-dir = "/storage/torrents";
        incomplete-dir-enabled = false;
        rpc-bind-address = "0.0.0.0";
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

