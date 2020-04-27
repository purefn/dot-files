{ config, pkgs, ... }:

{
  services = {
    keybase.enable = true;

    kbfs = {
      enable = true;
      extraFlags = [ "-label %u" ];
    };

    locate.enable = true;

    ntp = {
      enable = true;
      servers = ["server.local" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
    };

    openssh.enable = true;

    tailscale.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--bip=172.17.42.1/16";
    };
  };
}
