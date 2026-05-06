{ lib, platform, ... }:

{
  imports = [
    ./basic
    ./desktop
    ./laptop
  ] ++ lib.optionals (platform == "nixos") [
    ./mediaserver
  ];

  options.profiles = {
    basic.enable = lib.mkEnableOption "basic profile";
    desktop.enable = lib.mkEnableOption "desktop profile";
    laptop.enable = lib.mkEnableOption "laptop profile";
    mediaserver.enable = lib.mkEnableOption "mediaserver profile";
  };
}
