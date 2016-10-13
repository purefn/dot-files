{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "sbt-extras-${version}";
  version = "640268ca197d0a10bb2f1199f4c29e7b0cc32013";

  src = fetchFromGitHub {
    owner = "paulp";
    repo = "sbt-extras";
    rev = "${version}";
    sha256 = "1qp3bgjxnff75ccp8imiakhv6dv5l1w6vcbf34df37qq50n655rg";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin

    install bin/sbt $out/bin
  '';
}
