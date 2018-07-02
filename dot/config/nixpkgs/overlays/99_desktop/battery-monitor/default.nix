{ stdenv, fetchFromGitHub, python3, acpi, gobjectIntrospection, libappindicator, libnotify, makeWrapper, wrapGAppsHook }:

let
  pname = "battery-monitor";
  version = "v0.6";
  python = python3.withPackages (ps: with ps; [ pygobject3 ]);
in stdenv.mkDerivation {
  name = "${pname}-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "maateen";
    repo = pname;
    rev = version;
    sha256 = "04p3m34p6489hcrx3ir0wki2g36npsid4lm51lmy9rn5ki69hdbd";
  };

  dontBuild = true;

  buildInputs = [ gobjectIntrospection libappindicator libnotify makeWrapper python wrapGAppsHook ];

  installPhase = ''
    mkdir -p $out/share/battery-monitor
    cp -a $src/src/* $out/share/battery-monitor

    mkdir -p $out/bin

    makeWrapper ${python.interpreter} $out/bin/battery-monitor  \
      --set PATH "$PATH:${acpi}/bin"                            \
      --set PYTHONPATH "$PYTHONPATH:$out/share/battery-monitor" \
      --add-flags "$out/share/battery-monitor/run.py"
  '';
}
