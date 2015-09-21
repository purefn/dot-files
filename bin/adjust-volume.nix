with import <nixpkgs> {};

let
  ghc = haskellPackages.ghcWithPackages (p: with p; [ turtle ]);
in 
  runCommand "dummy" { buildInputs = [ ghc ]; } ""

