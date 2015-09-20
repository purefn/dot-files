{ pkgs, config, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  sound.enableOSSEmulation = false;
}
