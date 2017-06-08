# http://downloads.hipchat.com.s3.amazonaws.com/getdembitz/linux/deb/64/alpha/bananainternal_1.0.0_amd64.deb
# nix-build banana.nix --arg src ./bananainternal_1.0.0_amd64.deb

{ src }:

with import <nixpkgs> { };

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
    gnome.GConf
    gtk
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
  version = "1.0.0";
  name = "banana-${version}";

  inherit src;

  phases = "unpackPhase installPhase";

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase =''
    mkdir $out
    mv usr/* $out/
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      "$out/bin/bananainternal"
  '';
}
