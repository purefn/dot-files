self: super:

{
  adjust-volume = super.haskellPackages.callPackage ./adjust-volume {};

  mumble = super.mumble.override { pulseSupport = true; };

  neovim = super.neovim.override {
    extraPythonPackages = [
      # for ensime-vim
      super.pythonPackages.websocket_client
      super.pythonPackages.sexpdata
      super.pythonPackages.neovim
    ];
  };

  nix-ghci = super.callPackage ./nix-ghci {};

  sbt-extras = super.callPackage ./sbt-extras {};

  xmonad =
    (super.xmonad-with-packages.override {
      ghcWithPackages = super.haskellPackages.ghcWithPackages;
      packages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
        hpkgs.taffybar
      ];
    });
}
