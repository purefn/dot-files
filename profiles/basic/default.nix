{ config, pkgs, lib, platform, ... }:

{
  imports =
    (if platform == "nixos" then [
      ./nixos/erase-your-darlings.nix
      ./nixos/sops
      ./nixos/home-manager.nix
    ] else if platform == "darwin" then [
      ./darwin
    ] else []);

  # Conditional config - only active when basic profile is enabled
  config = lib.mkIf config.profiles.basic.enable (lib.mkMerge (
    lib.optionals (platform == "nixos") [
      (import ./nixos/system.nix { inherit config pkgs; })
      (import ./nixos/services.nix { inherit config pkgs; })
      (import ./nixos/networking.nix { inherit config pkgs; })
    ]
  ));
}
