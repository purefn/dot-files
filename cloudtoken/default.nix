{ stdenv, pkgs, python3Packages, fetchgit, fetchgitPrivate }:

let
  srcRoot = fetchgit {
    url = "https://bitbucket.org/atlassian/cloudtoken.git";
    rev = "c814b2b635224004da36f76a391e35bae4fe76ee";
    sha256 = "1zabj892i8njia0rhfaiv50d83kd5dcq711x2svql2f5c2yk07vq";
  };

  ver = "0.1.6";

  shellExporter = python3Packages.buildPythonPackage rec {
    name = "cloudtoken-plugin.shell-exporter-${ver}";
    version = ver;

    preConfigure = ''
      export VERSION="${ver}";
    '';

    doCheck = false;

    src = "${srcRoot}/plugins/shell-exporter-plugin";

    patches = [ ./fix-shell-exporter.patch ];
  };

  jsonExporter = python3Packages.buildPythonPackage rec {
    name = "cloudtoken-plugin.json-exporter-${ver}";
    version = ver;

    preConfigure = ''
      export VERSION="${ver}";
    '';

    doCheck = false;

    src = "${srcRoot}/plugins/json-exporter-plugin";
  };

  saml = python3Packages.buildPythonPackage rec {
    name = "cloudtoken-plugin.saml-${ver}";
    version = ver;

    preConfigure = ''
      export VERSION="${ver}";
    '';

    doCheck = false;

    src = "${srcRoot}/plugins/saml-plugin";

    propagatedBuildInputs = with python3Packages; [ boto3 ];

    patches = [ ./rm-circular-dep-saml.patch ];
  };

  # an older version is strictly required
  keyring = python3Packages.buildPythonPackage rec {
    name = "keyring-${version}";
    version = "8.7";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/keyring/${name}.tar.gz";
      sha256 = "0482rmi2x6p78wl2kz8qzyq21xz1sbbfwnv5x7dggar4vkwxhzfx";
    };

    buildInputs = with python3Packages;
      [ fs gdata python_keyczar mock pyasn1 pycrypto pytest_28 six setuptools_scm pytestrunner ];

    propagatedBuildInputs = [ python3Packages.secretstorage ];

    checkPhase = ''
      py.test $out
    '';

    meta = with stdenv.lib; {
      description = "Store and access your passwords safely";
      homepage    = "https://pypi.python.org/pypi/keyring";
      license     = licenses.psfl;
      maintainers = with maintainers; [ lovek323 ];
      platforms   = platforms.unix;
    };
  };

  keyringsAlt = python3Packages.buildPythonPackage rec {
    name = "keyrings.alt-${version}";
    version = "2.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/keyrings.alt/${name}.tar.gz";
      sha256 = "19l5mlr5n70997xx9zkmbgx77xzjmb48ymmh4s4knh8vkxpbsf7l";
    };

    propagatedBuildInputs = [ python3Packages.six ];

    doCheck = false;
  };

  getpass2 = python3Packages.buildPythonPackage rec {
    name = "getpass2-${version}";
    version = "1.0.2";

    src = pkgs.fetchurl {
      url = "mirror://pypi/g/getpass2/${name}.zip";
      sha256 = "0v53b4921jr4k32nwjnl2arbxi6b8sbsp8f50h54ppzzjzbjjk80";
    };

    doCheck = false;
  };

  atlassianPlugins = python3Packages.buildPythonPackage rec {
    name = "cloudtoken-plugin.atlassian_plugins-${version}";
    version = "0.1.12";

    src = fetchgitPrivate {
      url = "ssh://git@bitbucket.org/atlassian/cloudtoken-atlassian-plugins.git";
      rev = "3354883bb5ecb487579e36e8f4f3342972fd4d3f";
      sha256 = "1s7iw2m5l4b9p84xf35xmwgsqg9dlplqk5z8gfimkpc22ysl4aqz";
    };

    preConfigure = ''
      export VERSION="${version}";
    '';

    doCheck = false;

    patches = [ ./rm-circular-dep-idp.patch ];

    propagatedBuildInputs = [ keyring keyringsAlt getpass2 python3Packages.requests ];
  };

  # an updated version because the version in nixpkgs master is 0.3.2
  schedule = python3Packages.buildPythonPackage rec {
    name = "schedule-0.4.2";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/ce/35/a36d7952e3a8bd2a9da18f791eef64d13e487406716e3caeb7311c044d89/schedule-0.4.2.tar.gz";
      sha256 = "04c6mskr036ry57dpix17x9ycgy7jfk0m1fjmc1nz0l6rqzvhgwk";
    };

    buildInputs = with python3Packages; [ mock ];

    meta = with stdenv.lib; {
      description = "Python job scheduling for humans";
      homepage = https://github.com/dbader/schedule;
      license = licenses.mit;
    };
  };

in
  python3Packages.buildPythonPackage rec {
    name = "cloudtoken-${ver}";
    version = ver;

    src = "${srcRoot}/cloudtoken";

    patches = [ ./fish.patch ./paths.patch ];

    preConfigure = ''
      export VERSION="${ver}";
    '';

    postInstall = ''
      substituteInPlace $out/bin/cloudtoken --replace "@OUT@" "$out"

      for i in $out/share/cloudtoken/shell_additions/*; do
        substituteInPlace "$i" --replace "@OUT@" "$out"
      done
    '';

    propagatedBuildInputs = with python3Packages; [
      shellExporter
      jsonExporter
      saml
      atlassianPlugins

      watchdog
      flask
      schedule
      pyyaml
    ];
  }
