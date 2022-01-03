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
        ./misc
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
