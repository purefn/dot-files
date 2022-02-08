{ pkgs, config, ... }:

{
  imports = [
    ./desktop/default.nix
  ];

  programs.light.enable = true;

  services = {
    actkbd = {
      enable = true;
      bindings = [
        { keys = [ 224 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -U 10"; }
        { keys = [ 225 ]; events = [ "key" ]; command = "${pkgs.light}/bin/light -A 10"; }
      ];
    };

    cpupower-gui.enable = true;

    logind.lidSwitchExternalPower = "ignore";

    upower.enable = true;

    thermald.enable = true;

    xserver.libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = false;
        middleEmulation = true;
        tapping = true;
      };
    };
  };
}
