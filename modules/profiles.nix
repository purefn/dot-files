{ lib, ... }:

{
  imports = [
    ./profiles/basic.nix
    ./profiles/desktop.nix
    ./profiles/laptop.nix
    ./profiles/mediaserver.nix
  ];

  options.profiles = {
    basic.enable = lib.mkEnableOption "basic profile";
    desktop.enable = lib.mkEnableOption "desktop profile";
    laptop.enable = lib.mkEnableOption "laptop profile";
    mediaserver.enable = lib.mkEnableOption "mediaserver profile";
  };
}
