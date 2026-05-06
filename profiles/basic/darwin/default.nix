{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.darwinModules.sops
    inputs.home-manager.darwinModules.home-manager
    ./sops.nix
    ./home-manager.nix
  ];

  options.users.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "Primary user account name for home-manager and secrets";
  };

  config = lib.mkIf config.profiles.basic.enable (
    import ./system.nix { inherit config pkgs; }
  );
}
