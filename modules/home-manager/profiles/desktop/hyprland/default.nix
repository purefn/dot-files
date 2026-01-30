{ pkgs, ...}:
{
  imports = [
    ./status-bar.nix
    ./launcher.nix
    ./screenshots.nix
    ./lock-idle.nix
    ./notifications.nix
    ./wallpaper.nix
  ];

  home.packages = [ pkgs.brightnessctl ];

  programs = {
    # hyprpolkitagent needed ??
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    systemd.variables = ["--all"];

    extraConfig = builtins.readFile ./hyprland.conf;

    settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "kitty";
        bind = [
          "$mainMod, Return, exec, $terminal"
          "$mainMod SHIFT, Q, killactive,"
        ];
      };
  };
}
