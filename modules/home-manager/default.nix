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
        (./. + "/${config.networking.hostName}.nix")
      ];

      home = {
        username = "rwallace";
        homeDirectory = "/home/rwallace";
        # sessionVariables.NIX_PATH = config.nix.nixPath;
        stateVersion = "22.05";
      };

      programs.home-manager.enable = true;
    };
  };
}
