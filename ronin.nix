{ config, pkgs, ... }:

{
  imports = [
    ./machines/Gazelle2021/configuration.nix
    ./modules/laptop.nix
  ];

  systemd.services.nix-daemon.environment.TMPDIR = "/nix/tmp";

  networking = {
    hostId = "06f0d967";
    hostName = "ronin";

    firewall.enable = false;
  };

  services = {
    autorandr = {
      enable = true;

      profiles =
        let
          edp-1 = {
            fingerprint = {
              eDP-1 = "00ffffffffffff0006af9d4000000000101c0104a5261678029675a356529c270c505400000001010101010101010101010101010101ce8f80b6703888403020a5007ed710000018ce8f80b670382e473020a5007ed710000018000000fe0041554f0a202020202020202020000000fe004231373348414e30342e30200a00cd";
            };
            config = position: {
              eDP-1 = {
                enable = true;
                crtc = 0;
                mode = "1920x1080";
                inherit position;
                primary = true;
                rate = "144.03";
                # x-prop-broadcast_rgb = "Automatic";
                # x-prop-colorspace = "Default";
                # x-prop-max_bpc = "12";
                # x-prop-non_desktop = "0";
                # x-prop-scaling_mode = "Full aspect";
              };
            };
          };
        in  {
          home = {
            fingerprint = edp-1.fingerprint // {
              HDMI-1 =
              "00ffffffffffff0010ace9a04c3231310d1d0103803d2378eeee95a3544c99260f5054a54b00714f8180a9c0a940d1c0e1000101010108e80030f2705a80b0588a00615d2100001a000000ff00344b38583739334f3131324c0a000000fc0044454c4c205532373138510a20000000fd0031560a893c000a20202020202001ee02033ef15861605f5e5d10050402071601141f1213272021220306111523091f07830100006d030c001000307820006003020167d85dc40178c003e20f03565e00a0a0a0295030203500615d2100001a04740030f2705a80b0588a00615d2100001ebf1600a08038134030203a00615d2100001a00000000000000000000002e";
            };
            config = edp-1.config "907x2160" // {
              HDMI-1 = {
                enable = true;
                crtc = 1;
                mode = "3840x2160";
                position = "0x0";
                rate = "60.00";
                # x-prop-aspect_ratio = "Automatic";
                # x-prop-audio = "auto";
                # x-prop-broadcast_rgb = "Automatic";
                # x-prop-colorspace = "Default";
                # x-prop-max_bpc = "12";
                # x-prop-non_desktop = "0";
              };
            };
          };
          away = {
            inherit (edp-1) fingerprint;
            config = edp-1.config "0x0" // {
              HDMI-1.enable = false;
            };
          };
        };
    };
  };

  system.stateVersion = "22.05";
}

