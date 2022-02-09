{
  sops = {
    defaultSopsFile = ./secrets.yaml;

    # age.keyFile = "/var/lib/sops-nix/key.txt";
    # age.generateKey = true;
  };
}
