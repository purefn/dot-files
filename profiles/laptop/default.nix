{ config, pkgs, lib, platform, ... }:

{
  imports = lib.optionals (platform == "nixos") [
    ./nixos
  ];
}
