{ config, ...}:

{
  sops = {
    defaultSopsFile = ./secrets.yaml;

    secrets."passwords/root".neededForUsers = true;
    secrets."passwords/rwallace".neededForUsers = true;

    # sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    # sops.age.keyFile = "/var/lib/sops-nix/key.txt";
    # sops.age.generateKey = true;
  };

  users = {
    users = {
      root.initialHashedPassword = "$6$gdpMMTVeVitX0$jbXCRI/yWr6AzsL2K2VyPvNApb0xb8iipCkv2SPCALf3dz9vRjKlPRUFVWgd2OOA7ZJeRs8sFSNL0rd072fHG.";
      rwallace.initialHashedPassword = "$6$caUyXsJ6$YqTfq2glYOMpbmONsO1iVXmmJjlOIDHNp9EATJeLApity2Bf6nAqrsoFmFS/Mb9qMLMyLNVEMMHVGJk4Zx4Bp.";
  #     root.passwordFile = config.sops.secrets."passwords/root".path;
  #     rwallace.passwordFile = config.sops.secrets."passwords/rwallace".path;
    };
  };
}
