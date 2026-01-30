{ config, pkgs, lib, ... }:

{
  # Regular module imports (always loaded, not conditional)
  imports = [
    ./nixos/erase-your-darlings.nix
    ./nixos/sops
    ./nixos/home-manager.nix
  ];

  # Conditional config - only active when basic profile is enabled
  config = lib.mkIf config.profiles.basic.enable (
    lib.mkMerge [
      (import ./nixos/system.nix { inherit config pkgs; })
      (import ./nixos/services.nix { inherit config pkgs; })
      (import ./nixos/networking.nix { inherit config pkgs; })
    ]
  );
}
