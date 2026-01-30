{ config, pkgs, lib, ... }:

{
  # Regular module imports (always loaded, not conditional)
  imports = [
    ./erase-your-darlings.nix
    ./sops
    ./home-manager.nix
  ];

  # Conditional config - only active when basic profile is enabled
  config = lib.mkIf config.profiles.basic.enable (
    lib.mkMerge [
      (import ./system.nix { inherit config pkgs; })
      (import ./services.nix { inherit config pkgs; })
      (import ./networking.nix { inherit config pkgs; })
    ]
  );
}
