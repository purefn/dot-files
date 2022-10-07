{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix }: {
    nixosConfigurations =
      let
        f = cfg: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            cfg

            {
              home-manager.users.rwallace.home.sessionVariables.NIX_PATH = "nixpkgs=${nixpkgs.outPath}";
              environment.etc."channels/nixpkgs".source = nixpkgs.outPath;
              nix = {
                registry.nixpkgs.flake = nixpkgs;
                nixPath = [ "nixpkgs=/etc/channels/nixpkgs" ];
              };
            }
          ];
        };
      in builtins.mapAttrs (_: f) {
        daedalus = ./daedalus.nix;
        ronin = ./ronin.nix;
        seedbox = ./seedbox.nix;
        tealc = ./tealc.nix;
      };
  };
}
