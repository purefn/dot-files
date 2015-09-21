{ nixpkgs ? import <nixpkgs> {}, compiler ? null }:

let
  hpkgs =
    if compiler == null
      then nixpkgs.pkgs.haskellPackages
      else nixpkgs.pkgs.haskell.packages.${compiler};
in
  hpkgs.callPackage ./adjust-volume.nix { }
