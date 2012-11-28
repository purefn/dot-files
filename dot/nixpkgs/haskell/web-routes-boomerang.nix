{ cabal, boomerang, mtl, parsec, text, webRoutes }:

cabal.mkDerivation (self: {
  pname = "web-routes-boomerang";
  version = "0.27.0";
  sha256 = "0xwm6zgpygfzapb7laz3vx26nbbhlpqkk955l79fj7y5rww5h8cp";
  buildDepends = [ boomerang mtl parsec text webRoutes ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
