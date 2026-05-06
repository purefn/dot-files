{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ sops age ssh-to-age ];

  sops = {
    defaultSopsFile = ../nixos/sops/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = pkgs.lib.listToAttrs (map (name: { inherit name; value = { owner = config.users.primaryUser; }; }) [
      "ssh/ed"
      "ssh/rsa"
      "ssh/c_deploy"
      "ssh/config"
    ]);
  };
}
