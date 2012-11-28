{ cabal, digestiveFunctors, happstackServer, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-happstack";
  version = "0.5.0.1";
  sha256 = "1wzymj8z1dm5p0y4rkxg2f9ib120nqm45yxm3rki6g8hc3harl5h";
  buildDepends = [ digestiveFunctors happstackServer text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Happstack backend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
