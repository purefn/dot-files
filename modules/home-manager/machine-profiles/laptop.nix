# left empty, the defaults are for a laptop

{ pkgs, config, ... }: {
  services = {
    # haven't been able to get the icon showing the taffybar, but the
    # notification messages are still useful
    cbatticon.enable = true;
  };

  systemd.user.services.intusurg-ssh-tunnel = {
    Service = {
      Environment = "SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh";
      ExecStart="${pkgs.openssh}/bin/ssh -D 8889 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -CN intusurg";
      Restart = "always";
      RestartSec = 5;
    };

    Install = { WantedBy = [ "default.target" ]; };
  };
}
