{ pkgs, config, ... }:

{
  services = {
    logind.extraConfig = ''
      HandleLidSwitch=suspend
      HandleSuspendKey=suspend
      LidSwitchIgnoreInhibited=yes
    '';

    upower.enable = true;

    thermald.enable = true;
  };
}
