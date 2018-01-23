{ stdenv, pkgs, buildGoPackage, fetchgitPrivate }:

buildGoPackage rec {
  name = "laas-cli-${version}";
  version = "5.0.0";

  goPackagePath = "stash.atlassian.com/laas/cli";

  src = fetchgitPrivate {
    url = "ssh://git@stash.atlassian.com:7997/laas/cli";
    rev = version;
    sha256 = "17y23p5rims13mlgmk0i9yrcfby6fv10hzjbgdmmg4pj56139w67";
  };

  goDeps = ./deps.nix;

  # use extra sources here so we can use fetchgitPrivate
  extraSrcs = [
    {
      goPackagePath = "stash.atlassian.com/laas/admin-api-client-go";
      src = fetchgitPrivate {
        url = "ssh://git@stash.atlassian.com:7997/laas/admin-api-client-go";
        rev = "31238629aafe788c95202259283d28707aa48488";
        sha256 = "0gkj1w6j18jb109a5ymr82jpvv62g7gwsy07swn3kgwv7zm31np1";
      };
    }
  ];

  patches = [ ./version.patch ];

  postPatch = ''
    substituteInPlace main.go --replace '@VERSION@' ${version}
  '';

  postInstall = ''
    mv $bin/bin/cli $bin/bin/laas
  '';
}
