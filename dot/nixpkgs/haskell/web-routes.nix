{ cabal, blazeBuilder, httpTypes, mtl, network, parsec, split, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "web-routes";
  version = "0.27.2";
  sha256 = "17kzxccw6pz0zh0cfn1hd0lfwz5v9zjx4fjzp68ai9labd2kb05h";
  buildDepends = [
    blazeBuilder httpTypes mtl network parsec split text utf8String
  ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
