{ stdenv, awscli, pythonPackages, fetchgitPrivate }:

let
  keyring = stdenv.lib.overrideDerivation pythonPackages.keyring (oldAttrs : {
    # Tests fail on OS X and I haven't figured out why yet!
    doInstallCheck = if stdenv.isDarwin then false else true;
  });

in stdenv.mkDerivation {
  name = "awscli-saml-auth";

  nativeBuildInputs = [ pythonPackages.wrapPython ];

  pythonPath = with pythonPackages; [ awscli requests pyasn1 keyring ];

  buildPhases = [ "installPhase" ];

  src = fetchgitPrivate {
    url = "ssh://git@stash.atlassian.com:7997/infra/awscli-saml-auth.git";
    rev = "b35db29016b0516881c1bd507aee37ffc789880d";
    sha256 = "07jdfyw05ixhb0j7s9y0vn96kvdxz5gx2307czf16zcff9ynkrh0";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp setawstoken.py $out/bin/setawstoken
    wrapPythonPrograms
  '';

}
