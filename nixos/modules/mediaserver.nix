{ config, pkgs, ... }:

{
  powerManagement.enable = false;

  environment.systemPackages = with pkgs; [ libtorrent unrar python27Packages.rarfile ];

  nixpkgs.config.packageOverrides = pkgs: {
    radarr = pkgs.callPackage ./radarr {};
  };

  services = {
    # flexget = {
      # enable = true;
      # user = "transmission";
      # homeDir = "/var/lib/flexget";
      # systemScheduler = false;
      # config = ''
        # variables: ${pkgs.writeText "flexget-secrets.yml" (builtins.readFile ./flexget/secrets.yml)}
        # ${builtins.readFile ./flexget/config.yml}
      # '';
    # };

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

    sickbeard = {
      enable = false;
      package = pkgs.stdenv.mkDerivation {
        name = "sickgear-wrapper";
        version = pkgs.sickgear.version;
        nativeBuildInputs = [ pkgs.makeWrapper pkgs.sickgear];
        phases = ["installPhase"];
        installPhase = ''
          mkdir $out
          makeWrapper ${pkgs.sickgear}/SickBeard.py $out/SickBeard.py --prefix PATH ":" "${pkgs.unrar}/bin"
        '';
      };
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

