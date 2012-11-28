{ cabal, happstackServer, text, webRoutes }:

cabal.mkDerivation (self: {
  pname = "web-routes-happstack";
  version = "0.23.4";
  sha256 = "0k47hpgjphm7df72x6b2cllkn7kn8iv9yy36m6lxc5rm8li4cvwa";
  buildDepends = [ happstackServer text webRoutes ];
  meta = {
    description = "Adds support for using web-routes with Happstack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
