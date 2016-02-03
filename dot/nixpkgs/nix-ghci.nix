{stdenv, nix, writeScriptBin }:

let
  nixGhci = writeScriptBin "nix-ghci" ''
    #!${stdenv.shell}
    args="$@"
    ${nix}/bin/nix-shell -p "haskellPackages.ghcWithPackages (p: with p; [ $args ])" --command ghci
  '';
in
  stdenv.mkDerivation {
    name = "nix-ghci-0";

    phases = "installPhase";

    installPhase = ''
      mkdir -p $out
      ln -s ${nixGhci}/bin $out/bin
    '';
  }
