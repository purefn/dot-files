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
  version = "1.4.32";
  name = "stride-${version}";

  src = fetchurl {
    url = https://stride-desktop-downloads.s3.amazonaws.com/releases/linux/deb/64/alpha/stride-alpha_amd64.deb;
    sha256 = "00qqw6fi54fh2k76ip7liw2jzazf7ksgyy2984nzd772s8q7h0g4";
  };

  phases = "unpackPhase installPhase";

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase =''
    mkdir "$out"
    mv usr/* "$out/"
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      "$out/bin/stride-alpha"
  '';
}
