# left empty, the defaults are for a laptop

{ pkgs, config, ... }: {
  imports = [ ../desktop ];
  services = {
    # haven't been able to get the icon showing the taffybar, but the
    # notification messages are still useful
    cbatticon.enable = true;
  };
}
