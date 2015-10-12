{ stdenv, ghcWithPackages }:

let
  adjustVolumeEnv = ghcWithPackages (self: [ 
    (self.callPackage adjust-volume/. { })
  ]);
in stdenv.mkDerivation {
  name = "adjust-volume";

  buildCommand = ''
    mkdir -p $out/bin
    cp ${adjustVolumeEnv}/bin/adjust-volume $out/bin/adjust-volume
  '';
}
