{ config, ...}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.rwallace = {
      imports = [
        ./bash
        ./dev
        (import ./misc { nixos-config = config; })
        ./neovim
      ];

      home = {
        username = "rwallace";
        homeDirectory = "/home/rwallace";
        # sessionVariables.NIX_PATH = config.nix.nixPath;
        stateVersion = "25.11";
      };

      programs.home-manager.enable = true;
    };
  };
}
