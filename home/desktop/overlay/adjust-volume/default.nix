{ mkDerivation, base, lib, libnotify, optparse-applicative, text
, turtle
}:
mkDerivation {
  pname = "adjust-volume";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base libnotify optparse-applicative text turtle
  ];
  license = lib.licenses.bsd3;
}
