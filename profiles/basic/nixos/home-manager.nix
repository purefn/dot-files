{ inputs, config, lib, ... }:

{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };

      users.rwallace = {
        imports = [
          # Base configs - always included
          ../home-manager/bash
          ../home-manager/dev
          (import ../home-manager/ssh { nixos-config = config; })
          inputs.nvf-config.homeManagerModules.nvf
          inputs.nvf-config.homeManagerModules.nvf-config
          inputs.direnv-instant.homeModules.direnv-instant
        ]
        # Automatically apply profile-specific home-manager configs
        ++ lib.optional config.profiles.desktop.enable ../../desktop/home-manager
        ++ lib.optional config.profiles.laptop.enable ../../laptop/home-manager;

        home = {
          username = "rwallace";
          homeDirectory = "/home/rwallace";
          stateVersion = "25.11";
        };

        programs.home-manager.enable = true;
      };
    };
  };
}
