{ stdenv, dpkg, fetchurl, openssl, libnl, buildFHSUserEnv,... }:

stdenv.mkDerivation {
  name = "falcon-sensor";
  version = "5.25.0-8902";
  arch = "amd64";
  src = ./falcon-sensor_5.25.0-8902_amd64.deb;

  buildInputs = [ dpkg ];

  sourceRoot = ".";

  unpackCmd = ''
      dpkg-deb -x "$src" .
  '';

  installPhase = ''
      cp -r ./ $out/
      realpath $out
  '';

  meta = with stdenv.lib; {
    description = "Crowdstrike Falcon Sensor";
    homepage    = "https://www.crowdstrike.com/";
    license     = licenses.unfree;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ravloony ];
  };
}
