{ inputs, config, lib, ... }:

{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.rwallace = {
        imports = [
          # Base configs - always included
          ../../home-manager/bash
          ../../home-manager/dev
          (import ../../home-manager/misc { nixos-config = config; })
          inputs.nvf-config.homeManagerModules.nvf
          inputs.nvf-config.homeManagerModules.nvf-config
        ]
        # Automatically apply profile-specific home-manager configs
        ++ lib.optional config.profiles.desktop.enable ../../home-manager/profiles/desktop
        ++ lib.optional config.profiles.laptop.enable ../../home-manager/profiles/laptop;

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
