{ cabal, blazeHtml, blazeMarkup, digestiveFunctors, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-blaze";
  version = "0.5.0.0";
  sha256 = "1gpj3a2mlmckksclrwjqdh753whpw9rlf7ikxkx0qldim95jj5g3";
  buildDepends = [ blazeHtml blazeMarkup digestiveFunctors text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Blaze frontend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
