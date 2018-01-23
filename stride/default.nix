{ stdenv, fetchurl, dpkg, alsaLib, atk, cairo, cups, dbus, expat, fontconfig
, freetype, gdk_pixbuf, glib, gnome2, nspr, nss, pango, udev, xorg }:
let
  fullPath = stdenv.lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gnome2.GConf
    gnome2.gtk
    nspr
    nss
    pango
    udev
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
  ] + ":${stdenv.cc.cc.lib}/lib64";
in
stdenv.mkDerivation rec {
  version = "1.7.16";
  name = "stride-${version}";

  src = fetchurl {
    url = "https://packages.atlassian.com/stride-apt-client/pool/stride_${version}_amd64.deb";
    sha256 = "1rk3i1qcr05a85v7bvi0jl6ayj3lawnv2sq01vgndjx4gx7345yh";
  };

  dontBuild = true;
  dontFixup = true;

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase =''
    mkdir "$out"
    mv usr/* "$out/"
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      "$out/bin/stride"
  '';
}
