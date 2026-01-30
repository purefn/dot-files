{ inputs, config, lib, ... }:

{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.rwallace = {
        imports = [
          # Base configs - always included
          ./bash
          ./dev
          (import ./misc { nixos-config = config; })
          inputs.nvf-config.homeManagerModules.nvf
          inputs.nvf-config.homeManagerModules.nvf-config
        ]
        # Automatically apply profile-specific home-manager configs
        ++ lib.optional config.profiles.desktop.enable ./profiles/desktop
        ++ lib.optional config.profiles.laptop.enable ./profiles/laptop;

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
