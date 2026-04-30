{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    direnv-instant = {
      url = "github:Mic92/direnv-instant/fb9079adcef8b8ef97f91a1385be7ab5e3ff2b18";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    htmx-skill = {
      url = "github:mintarasss/htmx-skill";
      flake = false;
    };

    anthropics-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, sops-nix, direnv-instant, ... }: {
    apps.x86_64-linux =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in {
        update = {
          type = "app";
          meta.description = "Update flake inputs and rebuild the active NixOS system";
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
        # Helper function to build a NixOS system configuration
        # Takes a machine config path and returns a complete system
        mkSystem = machineConfig: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            # External modules
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops

            # Profile system (basic, desktop, laptop, mediaserver)
            ./profiles

            # Machine-specific configuration
            machineConfig

            # Make nixpkgs available via nix channels and registry
            {
              environment.etc."channels/nixpkgs".source = nixpkgs.outPath;
              nix = {
                registry.nixpkgs.flake = nixpkgs;
                nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
              };
            }
          ];
        };
      in {
        # Laptop: System76 Gazelle with NVIDIA/Intel hybrid GPU
        ronin = mkSystem ./machines/ronin;

        # Media server: Shuttle XPC with Transmission, Sonarr, Radarr
        seedbox = mkSystem ./machines/seedbox;
      };
  };
}
