{ inputs, config, lib, platform, ... }:

{
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs platform; };

      users.${config.users.primaryUser} = {
        imports = import ../home.nix {
          inherit inputs lib;
          systemConfig = config;
          extraImports =
            lib.optional config.profiles.desktop.enable ../../desktop/home-manager;
        };

        home = {
          username = config.users.primaryUser;
          homeDirectory = lib.mkForce "/Users/${config.users.primaryUser}";
          stateVersion = "25.11";
        };

        programs.home-manager.enable = true;
      };
    };
  };
}
