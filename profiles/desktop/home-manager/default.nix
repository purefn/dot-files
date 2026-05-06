{ lib, platform, ... }:

{
  imports = [
    ./kitty.nix
  ] ++ lib.optionals (platform == "nixos") [
    ./linux.nix
  ];
}
