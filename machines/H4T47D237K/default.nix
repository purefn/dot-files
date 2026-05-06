{ config, pkgs, ... }:

{
  profiles.basic.enable = true;
  profiles.desktop.enable = true;

  users.primaryUser = "rwallace1";

  networking.hostName = "H4T47D237K";

  # To set up SOPS on this machine:
  # 1. Generate an age key: age-keygen -o ~/.config/sops/age/keys.txt
  # 2. Get the public key: age-keygen -y ~/.config/sops/age/keys.txt
  # 3. Add the public key to .sops.yaml under keys
  # 4. Re-encrypt secrets: sops updatekeys profiles/basic/nixos/sops/secrets.yaml

  nixpkgs.config.allowUnfree = true;

  # nvf and many of its plugins (codewindow, etc.) depend on the legacy
  # nvim-treesitter API. Pin to the legacy build until nvf migrates.
  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins = prev.vimPlugins // {
        nvim-treesitter = prev.vimPlugins.nvim-treesitter-legacy;
      };
    })
  ];

  system.stateVersion = 6;
}
