{ config, ...}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.rwallace = {
      imports = [
        ./bash
        ./desktop
        ./dev
        (import ./misc { nixos-config = config; })
        ./neovim
        (./. + "/${config.networking.hostName}.nix")
      ];

      home = {
        username = "rwallace";
        homeDirectory = "/home/rwallace";
      };

      programs.home-manager.enable = true;
    };
  };
}
