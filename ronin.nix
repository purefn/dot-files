{ config, pkgs, ... }:

{
  imports = [
    ./machines/Gazelle2021/configuration.nix
    ./modules/laptop.nix
  ];

  nix = {
    # buildMachines = [
    #   {
    #     hostName = "macos-builder";
    #     system = "x86_64-darwin";
    #     maxJobs = 1;
    #     speedFactor = 2;
    #   }
    # ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  systemd.services.nix-daemon.environment.TMPDIR = "/nix/tmp";

  networking = {
    hostId = "06f0d967";
    hostName = "ronin";

    firewall.enable = false;
  };

  # virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "21.11";
}

