{ stdenv, pkgs, buildGoPackage, fetchgitPrivate }:

buildGoPackage rec {
  name = "laas-cli-${version}";
  version = "4.2.5";

  goPackagePath = "stash.atlassian.com/laas/cli";

  src = fetchgitPrivate {
    url = "ssh://git@stash.atlassian.com:7997/laas/cli";
    rev = "77185146a50fecd1a528286fc9d06f6f7358a9c7";
    sha256 = "1xrngfpzl0i77ych7h9xgdzbsgsbycjgs4dcsala6mh869snpwqc";
  };

  goDeps = ./deps.nix;

  # use extra sources here so we can use fetchgitPrivate
  extraSrcs = [
    {
      goPackagePath = "stash.atlassian.com/laas/admin-api-client-go";
      src = fetchgitPrivate {
        url = "ssh://git@stash.atlassian.com:7997/laas/admin-api-client-go";
        rev = "247107b48a202a28e63e855e61761f52b7b0d512";
        sha256 = "033ksy7xqcb12dvpark9jcz3iq24q7absca0c1ljc3kcl7pss7d2";
      };
    }
  ];

  postInstall = ''
    mv $bin/bin/cli $bin/bin/laas
  '';
}
