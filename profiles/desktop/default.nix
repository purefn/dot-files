{ config, pkgs, lib, platform, ... }:

{
  imports = lib.optionals (platform == "nixos") [
    ./nixos
  ];

  config = lib.mkIf config.profiles.desktop.enable {
    profiles.basic.enable = true;
  };
}
