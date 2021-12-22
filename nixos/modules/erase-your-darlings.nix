{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/persist/dot-files/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
  };

  environment.etc =
    let
      link = x: { source = "/persist/etc/${x}"; };
      files = [
        "machine-id"
        "ssh/ssh_host_rsa_key"
        "ssh/ssh_host_rsa_key.pub"
        "ssh/ssh_host_ed25519_key"
        "ssh/ssh_host_ed25519_key.pub"
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
        "/etc/nixos" = mount "/dot-files/nixos";
      };

  users = {
    mutableUsers = false;
    users = {
      root.initialHashedPassword = "$6$gdpMMTVeVitX0$jbXCRI/yWr6AzsL2K2VyPvNApb0xb8iipCkv2SPCALf3dz9vRjKlPRUFVWgd2OOA7ZJeRs8sFSNL0rd072fHG.";
      rwallace.initialHashedPassword = "$6$caUyXsJ6$YqTfq2glYOMpbmONsO1iVXmmJjlOIDHNp9EATJeLApity2Bf6nAqrsoFmFS/Mb9qMLMyLNVEMMHVGJk4Zx4Bp.";
    };
  };
}
