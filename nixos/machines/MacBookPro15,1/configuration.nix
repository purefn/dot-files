# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/desktop.nix
      ../../modules/networking.nix
      ../../modules/services.nix
      ../../modules/system.nix
    ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };

    tmpOnTmpfs = true;
  };

  networking = {
    hostName = "tealc";
    firewall.enable = false;

    # extraHosts = ''
    #   192.168.39.196 portal.local minio.local minio-ova.local mattermost.local keycloak.local
    # '';
  };

  nix = {
    # maxJobs = pkgs.lib.mkForce 4;
    # buildCores = pkgs.lib.mkForce 2;
    daemonNiceLevel = 10;
  };

  fileSystems = {
    "/home/rwallace" = {
      fsType = "nfs";
      device = "172.16.18.1:/Users/richard/home";
      options = [
        "vers=3"
      ];
    };
  };

  virtualisation = {
    vmware.guest = {
      enable = true;
      headless = false;
    };

    # libvirtd.enable = true;
  };

  services = {
    collectd = {
      enable = true;
      autoLoadPlugin = true;
      extraConfig = ''
        Interval 1
        <Plugin rrdtool>
          DataDir "/var/lib/collectd"
          CreateFilesAsync false
          CacheTimeout 120
          CacheFlush   900
          WritesPerSecond 50
        </Plugin>
        <Plugin "df">
          MountPoint "/tmp"
        </Plugin>
        <Plugin cpu>
          ReportByCpu true
          ReportByState true
          ValuesPercentage false
          ReportNumCpu false
          ReportGuestState false
          SubtractGuestState true
        </Plugin>
        <Plugin memory>
          ValuesAbsolute true
        </Plugin>
        <Plugin swap>
          ReportIO false
        </Plugin>
      '';
    };
    lighttpd = {
      enable = true;
      collectd = {
        enable = true;
        collectionCgi = config.services.collectd.package.overrideDerivation(old: {
          name = "collection.cgi";
          dontConfigure = true;
          buildPhase = "true";
          installPhase = ''
            substituteInPlace contrib/collection.cgi  \
              --replace '"/etc/collection.conf"' '$ENV{COLLECTION_CONF}' \
              --replace 'hour => 3600,' 'hour => 3600, threehour => 3600*3,' \
              --replace 'Hour Day Week Month Year' 'Hour Threehour Day Week Month Year'
            cp contrib/collection.cgi $out
          '';
        });
      };
    };

    nfs.server = {
      enable = true;
      exports = ''
        /portal-appliance/mongodb 192.168.39.0/24(insecure,rw,sync,no_subtree_check,fsid=1)
        /portal-appliance/db 192.168.39.0/24(insecure,rw,sync,no_subtree_check,no_root_squash,fsid=2)
        /portal-appliance/data 192.168.39.0/24(insecure,rw,sync,no_subtree_check,fsid=3)
        /portal-appliance/logs 192.168.39.0/24(insecure,rw,sync,no_subtree_check,fsid=4)
        /portal-appliance/backups 192.168.39.0/24(insecure,rw,sync,no_subtree_check,fsid=5)
        /portal-appliance/provisioning 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=6)
        /portal-appliance/seeddata 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=7)
        /portal-appliance/minio 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=8)
        /portal-appliance/minio-ova 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,root_squash,fsid=9)
        /portal-appliance/keycloakpostgres 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,no_root_squash,fsid=10)
        /portal-appliance/mattermost 192.168.39.0/24(insecure,rw,sync,no_subtree_check,anonuid=1000,anongid=20,no_root_squash,fsid=11)
      '';
    };

    # openvpn.servers = {
    #   simspace = {
    #     config = ''
    #       config /var/lib/vpn/Simspace-UDP-richard.wallace.conf
    #     '';
    #     updateResolvConf = true;
    #   };
    # };

    # minio = {
    #   enable = true;
    #   accessKey = "minioadmin";
    #   secretKey = "password";
    # };

    # postgresql = {
    #   enable = true;
    #   package = pkgs.postgresql_9_6;
    # };

    # mongodb = {
    #   enable = true;
    # };
  };

  systemd.services = {
    falcon-sensor = import ../../modules/falcon-sensor/falcon.nix {
      inherit pkgs;
    };
  };

  programs = {
    ssh.extraConfig = ''
      Host * !192.168.99.* !172.16.18.*
        ProxyJump richard@172.16.18.1
    '';
  };

  # system.stateVersion = "19.03"; # Did you read the comment?


#   services.kubernetes = {
#     easyCerts = true;
#     addons.dashboard.enable = true;
#     roles = ["master" "node"];
#     # apiserver = {
#     #   securePort = 443;
#     #   # advertiseAddress = config.networking.privateIPv4;
#     # };
#     kubelet.extraOpts = "--fail-swap-on=false";
#     masterAddress = "tealc";
#   };
#   services.dockerRegistry.enable = true;
}
