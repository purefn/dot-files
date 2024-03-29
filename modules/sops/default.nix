{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ sops age ssh-to-age ];

  sops = {
    defaultSopsFile = ./secrets.yaml;

    secrets = {
      "passwords/root".neededForUsers = true;
      "passwords/rwallace".neededForUsers = true;
      "vpn/pia" = {};
    } // pkgs.lib.listToAttrs (map (name: { inherit name; value = { owner = "rwallace"; }; }) [
      "ssh/ed"
      "ssh/rsa"
      "ssh/c_deploy"
      "ssh/config"
    ]);
  };
}
