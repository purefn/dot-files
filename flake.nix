{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, sops-nix, direnv-instant, ... }:
    let
      # Shared nixpkgs/registry config applied to all system types
      nixpkgsRegistryModule = {
        environment.etc."channels/nixpkgs".source = nixpkgs.outPath;
        nix = {
          registry.nixpkgs.flake = nixpkgs;
          nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
        };
      };

      # Build a NixOS system configuration
      mkNixOS = machineConfig: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; platform = "nixos"; };
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./profiles
          machineConfig
          nixpkgsRegistryModule
        ];
      };

      # Build a nix-darwin system configuration
      mkDarwin = { system ? "aarch64-darwin", machineConfig }: darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs; platform = "darwin"; };
        modules = [
          ./profiles
          machineConfig
          nixpkgsRegistryModule
        ];
      };

      # Build a standalone home-manager configuration (no NixOS/darwin system)
      mkHome = { system, username, homeDirectory, extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs; };
          modules = [
            { imports = import ./profiles/basic/home.nix { inherit inputs; lib = nixpkgs.lib; }; }
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "25.11";
              };
              programs.home-manager.enable = true;
            }
          ] ++ extraModules;
        };
    in {

    # --- Apps ---

    apps.x86_64-linux =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in {
        update = {
          type = "app";
          meta.description = "Update flake inputs and rebuild the active NixOS system";
          program = "${pkgs.writeShellScript "update" ''
            set -e
            ${pkgs.nix}/bin/nix flake update
            ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${./.} --use-remote-sudo
          ''}";
        };
      };

    apps.aarch64-darwin =
      let pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      in {
        update = {
          type = "app";
          meta.description = "Update flake inputs and rebuild the active darwin system";
          program = "${pkgs.writeShellScript "update" ''
            set -e
            ${pkgs.nix}/bin/nix flake update
            darwin-rebuild switch --flake ${./.}
          ''}";
        };
      };

    # --- NixOS ---

    nixosConfigurations = {
      # Laptop: System76 Gazelle with NVIDIA/Intel hybrid GPU
      ronin = mkNixOS ./machines/ronin;

      # Media server: Shuttle XPC with Transmission, Sonarr, Radarr
      seedbox = mkNixOS ./machines/seedbox;
    };

    # --- nix-darwin ---

    darwinConfigurations = {
      H4T47D237K = mkDarwin {
        machineConfig = ./machines/H4T47D237K;
      };
    };

    # --- Standalone home-manager ---

    homeConfigurations = {
      # Fallback for machines without NixOS or nix-darwin
      "rwallace" = mkHome {
        system = "x86_64-linux";
        username = "rwallace";
        homeDirectory = "/home/rwallace";
      };

      "rwallace1" = mkHome {
        system = "aarch64-darwin";
        username = "rwallace1";
        homeDirectory = "/Users/rwallace1";
      };
    };
  };
}
