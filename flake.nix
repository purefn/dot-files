{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations =
      let
        f = cfg: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            cfg
          ];
        };
      in builtins.mapAttrs (_: f) {
        ronin = ./ronin.nix;
        daedalus = ./daedalus.nix;
      };
  };
}
