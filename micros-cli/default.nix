{pkgs ? import <nixpkgs> {
    inherit system;
  }, system ? builtins.currentSystem, nodejs ? pkgs."nodejs-4_x"}:

let
  nodeEnv = import ./node-env.nix {
    inherit (pkgs) stdenv python2 utillinux runCommand writeTextFile;
    inherit nodejs;
  };

  nodePackages = import ./node-packages.nix {
    inherit (pkgs) fetchurl fetchgitPrivate srcOnly;
    inherit nodeEnv;
  };

  microsCli = nodePackages.package.override (oldAttrs: {
    # patchPhase = ''
     # pwd
     # ls -la
     # cat env-vars
     # echo $packageName
     # echo Patching netrc
     # ${pkgs.patch}/bin/patch -p1 < ${./netrc.patch}
    #'';
    # patches = [ ./netrc.patch ];
  });
in
  microsCli
