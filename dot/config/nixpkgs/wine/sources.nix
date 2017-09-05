{ pkgs ? import <nixpkgs> {} }:
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
in rec {

  stable = fetchurl rec {
    version = "2.0.2";
    url = "https://dl.winehq.org/wine/source/2.0/wine-${version}.tar.xz";
    sha256 = "16iwf48cfi39aqyy8131jz4x7lr551c9yc0mnks7g24j77sq867p";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.47";
      url = "http://dl.winehq.org/wine/wine-gecko/${version}/wine_gecko-${version}-x86.msi";
      sha256 = "0fk4fwb4ym8xn0i5jv5r5y198jbpka24xmxgr8hjv5b3blgkd2iv";
    };
    gecko64 = fetchurl rec {
      version = "2.47";
      url = "http://dl.winehq.org/wine/wine-gecko/${version}/wine_gecko-${version}-x86_64.msi";
      sha256 = "0zaagqsji6zaag92fqwlasjs8v9hwjci5c2agn9m7a8fwljylrf5";
    };

    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "4.7.0";
      url = "http://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}.msi";
      sha256 = "18d5djnsb70740xs475jg1xsjsrq6zzjv0dmjq3vi7nbv56lg63n";
    };
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "2.13";
    url = "https://dl.winehq.org/wine/source/2.x/wine-${version}.tar.xz";
    sha256 = "1y3yb01lg90pi8a9qjmymg7kikwkmvpkjxi6bbk1q1lvs7fs7g3g";
    inherit (stable) mono gecko32 gecko64;
  };

  staging = fetchFromGitHub rec {
    inherit (unstable) version;
    # sha256 = "1ivjx5pf0xqqmdc1k5skg9saxgqzh3x01vjgypls7czmnpp3aylb";
    # owner = "wine-compholio";
    # repo = "wine-staging";
    # rev = "v${version}";
    sha256 = "1vmmjc5xrxlmb08452kiak6gk3cksfwyb36dbn47923il5pd8p24";
    owner = "gamax92";
    repo = "wine-overwatch";
    rev = "389c7a23572e3a991ff30404c4bed77436baf3cc";
  };

  overwatch = fetchFromGitHub rec {
    inherit (unstable) version;
    sha256 = "1ivjx5pf0xqqmdc1k5skg9saxgqzh3x01vjgypls7czmnpp3aylb";
    owner = "gamax92";
    repo = "wine-overwatch";
    rev = "389c7a23572e3a991ff30404c4bed77436baf3cc";
  };

  winetricks = fetchFromGitHub rec {
    version = "20170614";
    sha256 = "1xszflrdmixxr0v7vjby8fpnl8fgc9gldr1gnjpwzq1rnb84idqa";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };

}