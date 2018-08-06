{ pkgs }:
{
  allowUnfree = true;

  chromium = {
    # enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash
    enablePepperPDF = true;
    # enableWideVine = true;
    pulseSupport = true;
  };

  MPlayer = {
    pulseSupport = true;
  };
}
