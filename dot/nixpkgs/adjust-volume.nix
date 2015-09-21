{ stdenv, ghcWithPackages, makeWrapper }:

let
  adjustVolumeEnv = ghcWithPackages (self: [ 
    (self.callPackage adjust-volume/. { })
  ]);
in stdenv.mkDerivation {
  name = "adjust-volume";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${adjustVolumeEnv}/bin/adjust-volume $out/bin/adjust-volume
  '';
}
