{ pkgs, inputs, ... }:

let
  # Android emulator with Google Play Store support
  androidEnv = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "34" ];
    # abiVersions = [ "arm64-v8a" ];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ "google_apis_playstore" ];
    includeSources = false;
    includeNDK = false;
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };

  android-emulator = pkgs.writeShellScriptBin "android-emulator" ''
    export ANDROID_SDK_ROOT="${androidEnv.androidsdk}/libexec/android-sdk"

    # Force X11/XWayland - keyboard doesn't work properly on native Wayland
    export QT_QPA_PLATFORM=xcb

    # Create AVD if it doesn't exist
    AVD_DIR="$HOME/.android/avd"
    AVD_NAME="pixel_playstore"

    if [ ! -d "$AVD_DIR/$AVD_NAME.avd" ]; then
      echo "Creating AVD '$AVD_NAME'..."
      mkdir -p "$AVD_DIR"
      echo "no" | ${androidEnv.androidsdk}/bin/avdmanager create avd \
        --name "$AVD_NAME" \
        --package "system-images;android-34;google_apis_playstore;arm64-v8a" \
        --device "pixel_6"
      # Enable hardware keyboard
    ignores = [
      "*~"
      ".*.swn"
      ".*.swp"
      ".*.swo"
    ];

    # lfs.enable = true;
      echo "hw.keyboard=yes" >> "$AVD_DIR/$AVD_NAME.avd/config.ini"
    fi

    # Ensure hw.keyboard is enabled (for existing AVDs)
    if ! grep -q "^hw.keyboard=yes" "$AVD_DIR/$AVD_NAME.avd/config.ini" 2>/dev/null; then
      echo "hw.keyboard=yes" >> "$AVD_DIR/$AVD_NAME.avd/config.ini"
    fi

    # Run the emulator
    exec ${androidEnv.androidsdk}/bin/emulator \
      -avd "$AVD_NAME" \
      -gpu swiftshader_indirect \
      "$@"
  '';
in
{
  home = {
    file = {
      ".ghci".source = ./ghci;
      ".stack/config.yaml".source = ./stack.yaml;
    };
    packages = with pkgs; [
      # general dev
      cachix
      ctags
      # darcs
      gnumake
      # ngrok
      binutils-unwrapped

      # haskell dev
      # all-hies
      cabal-install
      (pkgs.callPackage ./overlay/nix-ghci {})
      # haskell-ide-engine
      haskellPackages.cabal2nix
      haskellPackages.cabal-fmt
      # haskellPackages.codex
      haskellPackages.ghcid
      # haskellPackages.hasktags
      haskellPackages.hlint
      # haskellPackages.hscope
      haskellPackages.hserv
      # haskellPackages.packunused
      haskellPackages.pandoc
      # haskellPackages.pointful
      # haskellPackages.pointfree

      # nix
      haskellPackages.nixfmt
      niv

      # k8s
      kubectl
      kubernetes-helm
      helmsman
      terragrunt

    ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      # android (linux only)
      android-emulator
      androidEnv.androidsdk
    ];
  };

  services.podman = {
    enable = true;
    # The home-manager activation script runs with a locked-down PATH that
    # excludes /usr/bin and ~/.nix-profile/bin, so `podman machine init` on
    # darwin can't find ssh-keygen. Wrap podman to put openssh on its PATH.
    package = pkgs.symlinkJoin {
      name = "podman-with-openssh";
      paths = [ pkgs.podman ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/podman \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.openssh ]}
      '';
      meta.mainProgram = "podman";
    };
  };

  programs = {
    claude-code = {
      enable = true;
      skills = {
        htmx = "${inputs.htmx-skill}/htmx";
        frontend-design = "${inputs.anthropics-skills}/skills/frontend-design";
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      # options.side-by-side = true;
    };

    git = {
      enable = true;
      # package = pkgs.gitAndTools.gitFull;

      settings = {
        user = {
          name = "Richard Wallace";
          email = "rwallace@thewallacepack.net";
        };

        alias = {
          st = "status";
          ci = "commit";
          co = "checkout";
          br = "branch";
        };

        checkout.defaultRemote = "origin";
        core.editor = "nvim";
        merge.tool = "nvimdiff";
        "mergetool \"nvimdiff\"".cmd = "nvim -d \"$LOCAL\" \"$MERGED\" \"$BASE\" \"$REMOTE\" -c \"wincmd w\" -c \"wincmd J\"";
        pull.rebase = false;
        push.autoSetupRemote = true;
        rerere = {
          enabled = true;
          autoupdate = true;
        };
      };

      ignores = [
        "*~"
        ".*.swn"
        ".*.swp"
        ".*.swo"
      ];

      # lfs.enable = true;
    };

  };
}
