{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.rwallace = import ./rwallace.nix;
  };
}
