# left empty, the defaults are for a laptop

{ pkgs, config, ... }: {
  services = {
    # haven't been able to get the icon showing the taffybar, but the
    # notification messages are still useful
    cbatticon.enable = true;
  };

  systemd.user.services.socks5-proxy-gut = {
    Service = {
      ExecStart="${pkgs.openssh}/bin/ssh -D 8889 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -CN gut";
      Restart = "always";
      RestartSec = 5;
    };

    Install = { WantedBy = [ "default.target" ]; };
  };
}
