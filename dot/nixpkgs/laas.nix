{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "laas-${version}";
  version = "4.0.0";

  src = fetchurl {
    url = "https://statlas.atlassian.io/laas/laas_${version}_linux_amd64.tar.gz";
    sha256 = "1pqggildnaf05h30g1l99jcm3hi3zjhdx7z98cm524370vsl2zrm";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp laas $out/bin/laas.wrapped
    echo $(< $NIX_CC/nix-support/dynamic-linker) $out/bin/laas.wrapped \"\$@\" > $out/bin/laas
    chmod +x $out/bin/laas
  '';
}
