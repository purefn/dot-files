{ lib, ... }:

{
  imports = [
    ./basic
    ./desktop
    ./laptop
    ./mediaserver
  ];

  options.profiles = {
    basic.enable = lib.mkEnableOption "basic profile";
    desktop.enable = lib.mkEnableOption "desktop profile";
    laptop.enable = lib.mkEnableOption "laptop profile";
    mediaserver.enable = lib.mkEnableOption "mediaserver profile";
  };
}
