{ lib, platform, ... }:

{
  imports = [
    ./kitty.nix
  ] ++ lib.optionals (platform == "nixos") [
    ./linux.nix
  ] ++ lib.optionals (platform == "darwin") [
    ./darwin.nix
  ];
}
