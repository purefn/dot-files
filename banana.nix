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
  version = "1.11.31";
  name = "banana-${version}";

  src = fetchurl {
    url = http://s3.amazonaws.com/downloads.hipchat.com/getdembitz/linux/deb/64/alpha/bananainternal-alpha_amd64.deb;
    sha256 = "0yfd6fy4y9ssjfyak2d47d6pfacbgzng7r2dm0nfxch75rwyz4ay";
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
      "$out/bin/bananainternal-alpha"
  '';
}
