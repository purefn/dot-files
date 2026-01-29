{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf-config = {
      url = "github:purefn/nvf-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, sops-nix, ... }: {
    apps.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in {
        update = {
          type = "app";
          program =
            let
              update = pkgs.writeShellScript "update" ''
                set -e
                ${pkgs.nix}/bin/nix flake update
                ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${./.} --use-remote-sudo
              '';
            in
              "${update}";
        };
    };
    nixosConfigurations =
      let
        f = cfg: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            cfg

            {
              environment.etc."channels/nixpkgs".source = nixpkgs.outPath;
              nix = {
                registry.nixpkgs.flake = nixpkgs;
                nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
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
