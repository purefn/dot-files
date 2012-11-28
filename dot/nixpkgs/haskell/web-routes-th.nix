{ cabal, parsec, split, text, webRoutes }:

cabal.mkDerivation (self: {
  pname = "web-routes-th";
  version = "0.22.1";
  sha256 = "0hnzf044rhrv4lxrha5xr9ivdh2lwd924293jz8v5hlbzhp2b5s1";
  buildDepends = [ parsec split text webRoutes ];
  meta = {
    description = "Support for deriving PathInfo using Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
