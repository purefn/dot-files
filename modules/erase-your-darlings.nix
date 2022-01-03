{ pkgs, ...}:

{
  boot = {
    supportedFilesystems = [ "zfs" ];

    # this wipes the root fs on reboot.
    #
    # note: currently commented out because i'm a coward.
    # i hope to someday work up the courage to do it
    # boot.initrd.postDeviceCommands = lib.mkAfter ''
    #   zfs rollback -r ${ZFS_BLANK_SNAPSHOT}
    # '';
  };

  environment.etc =
    let
      link = x: { source = "/persist/etc/${x}"; };
      files = [
        "machine-id"
      ];
    in
      pkgs.lib.genAttrs files link;

  fileSystems =
    let
      mount = x: {
        device = "/persist${x}";
        options = [ "bind" ];
      };
      dirs = [
        "var/log"
        "var/lib/systemd/coredump"
        "etc/NetworkManager/system-connections"
      ];
    in
      pkgs.lib.genAttrs (map (x: "/${x}") dirs) mount // {
        "/etc/nixos" = mount "/dot-files";
      };

  services = {
    openssh = {
      hostKeys = [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persist/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };

    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };
  };

  users = {
    mutableUsers = false;
    users = {
      root.initialHashedPassword = "$6$gdpMMTVeVitX0$jbXCRI/yWr6AzsL2K2VyPvNApb0xb8iipCkv2SPCALf3dz9vRjKlPRUFVWgd2OOA7ZJeRs8sFSNL0rd072fHG.";
      rwallace.initialHashedPassword = "$6$caUyXsJ6$YqTfq2glYOMpbmONsO1iVXmmJjlOIDHNp9EATJeLApity2Bf6nAqrsoFmFS/Mb9qMLMyLNVEMMHVGJk4Zx4Bp.";
    };
  };
}
