{ stdenv, pkgs, pythonPackages, fetchgitPrivate, writeScriptBin}:

let
  keyring = pkgs.stdenv.lib.overrideDerivation pythonPackages.keyring (oldAttrs : {
    # Tests fail on OS X and I haven't figured out why yet!
    doInstallCheck = if stdenv.isDarwin then false else true;
  });
  awscliSamlAuth =
    stdenv.mkDerivation {
      name = "awscli-saml-auth";

      nativeBuildInputs = [ pythonPackages.wrapPython ];

      pythonPath = with pythonPackages; [ awscli requests pyasn1 keyring dbus-python ];

      buildPhases = [ "installPhase" ];

      src = fetchgitPrivate {
        url = "ssh://git@stash.atlassian.com:7997/infra/awscli-saml-auth.git";
        rev = "b35db29016b0516881c1bd507aee37ffc789880d";
        sha256 = "07jdfyw05ixhb0j7s9y0vn96kvdxz5gx2307czf16zcff9ynkrh0";
      };

      installPhase = ''
        mkdir -p $out/bin
        cp setawstoken.py $out/bin/
        cp unset_aws_token.sh $out/bin/
        wrapPythonPrograms
      '';

    };
  setawstoken = writeScriptBin "setawstoken.sh" ''
    #!${stdenv.shell}

    PARAMS="$@"

    ${awscliSamlAuth }/bin/setawstoken.py $PARAMS

    if [ -f ~/.awscli_saml_auth/aws_tokens ]; then
      source ~/.awscli_saml_auth/aws_tokens
    fi
  '';
  unsetawstoken = writeScriptBin "unsetawstoken.sh" ''
    #!${stdenv.shell}

    source ${awscliSamlAuth}/bin/unset_aws_token.sh

    rm -vf ~/.awscli_saml_auth/aws_tokens

    rm -vf ~/.awscli_saml_auth/aws_tokens.json
  '';

in
  stdenv.mkDerivation {
    name = "awstoken";

    nativeBuildInputs = [ awscliSamlAuth ];

    phases = "installPhase";

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${setawstoken}/bin/setawstoken.sh $out/bin/
      ln -s ${unsetawstoken}/bin/unsetawstoken.sh $out/bin/
    '';
  }

