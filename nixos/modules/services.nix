{ config, pkgs, ... }:

{
  services = {
    locate.enable = true;

    mongodb.enable = true;

    ntp = {
      enable = true;
      servers = ["server.local" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
    };

    openssh.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql93;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--bip=172.17.42.1/16";
    };
    virtualbox.host = {
      enable = true;
      enableHardening = false;
    };
  };
}
