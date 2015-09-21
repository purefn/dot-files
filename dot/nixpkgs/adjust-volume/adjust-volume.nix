{ mkDerivation, base, optparse-applicative, stdenv, turtle, libnotify }:
mkDerivation {
  pname = "adjust-volume";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base optparse-applicative turtle libnotify ];
  license = stdenv.lib.licenses.bsd3;
}
