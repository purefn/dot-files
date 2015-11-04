{ config, pkgs, ... }:

{
  services = {
    locate.enable = true; 

    mongodb.enable = true;

    ntp = {
      enable = true;
      servers = ["server.local" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
    };

    # printing.enable = true;

    openssh.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql93;
    };
  };

  virtualisation.virtualbox.host.enable = true;
}
