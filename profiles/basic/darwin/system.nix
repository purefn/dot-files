{ config, pkgs, ... }:

{
  system.primaryUser = config.users.primaryUser;

  environment.shells = [ pkgs.bashInteractive ];

  # nix-darwin only honors users.users.<name>.shell for users it manages via
  # users.knownUsers, which means adopting the macOS account (UID/GID, etc.).
  # For pre-existing accounts, drive dscl directly during activation instead.
  system.activationScripts.postActivation.text = ''
    user=${config.users.primaryUser}
    desired=/run/current-system/sw/bin/bash
    current=$(/usr/bin/dscl . -read /Users/$user UserShell | awk '{print $2}')
    if [ "$current" != "$desired" ]; then
      echo "Setting login shell for $user: $current -> $desired"
      /usr/bin/dscl . -change /Users/$user UserShell "$current" "$desired"
    fi
  '';

  nix = {
    settings = {
      auto-optimise-store = true;
      cores = 0;
      max-jobs = "auto";
      trusted-users = [ "rwallace1" ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    dock = {
      autohide = true;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
  };
}
