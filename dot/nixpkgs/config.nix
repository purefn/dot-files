pkgs : {
  packageOverrides = pkgs : rec {
    mercPackages =
      let callPackage = pkgs.lib.callPackageWith mercPackages; in
        pkgs.recurseIntoAttrs (pkgs.haskellPackages.override {
          extraPrefs = self : {
            digestiveFunctorsBlaze = callPackage ./haskell/digestive-functors-blaze.nix {};
            digestiveFunctorsHappstack = callPackage ./haskell/digestive-functors-happstack.nix {};
            webRoutes = callPackage ./haskell/web-routes.nix {};
            webRoutesBoomerang = callPackage ./haskell/web-routes-boomerang.nix {};
            webRoutesHappstack = callPackage ./haskell/web-routes-happstack.nix {};
            webRoutesTh = callPackage ./haskell/web-routes-th.nix {};
          };
        });

    mercEnv = mercPackages.ghcWithPackages (self : [
      self.haskellPlatform
      self.boomerang
      self.digestiveFunctors
      self.digestiveFunctorsBlaze
      self.digestiveFunctorsHappstack
      self.happstackServer
      self.webRoutes
      self.webRoutesBoomerang
      self.webRoutesHappstack
      self.webRoutesTh
    ]);
  };

}

