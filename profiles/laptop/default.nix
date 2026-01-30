{ config, pkgs, lib, ... }:

{
  # Import NixOS configuration
  imports = [
    ./nixos
  ];
}
