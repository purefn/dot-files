{  pkgs, ... }:
let
  falcon = pkgs.callPackage ./. {};

  runFalconBin = bin:
    let
      env = pkgs.buildFHSUserEnv {
        name = bin;
        targetPkgs = pkgs: [ pkgs.libnl pkgs.openssl ];
        extraBuildCommands = ''
          mkdir -p opt/CrowdStrike
          for i in ${falcon}/opt/CrowdStrike/*; do
            ln -s "$i" opt/CrowdStrike/$(basename $i)
          done
        '';
        runScript = "${falcon}/opt/CrowdStrike/${bin}";
      };
    in
      "${env}/bin/${bin}";

  falconctl = runFalconBin "falconctl";

  falcond = runFalconBin "falcond";

in {
  enable = true;
  description = "CrowdStrike Falcon Sensor";
  after = [ "local-fs.target" ];
  conflicts = [ "shutdown.target" ];
  before = [ "shutdown.target" ];
  serviceConfig = {
    ExecStartPre = "${falconctl} -g --cid";
    ExecStart = "${falcond}";
    Type = "forking";
    PIDFile = "/var/run/falcond.pid";
    Restart = "no";
    TimeoutStopSec = "60s";
    KillMode = "process";
  };
  wantedBy = [ "multi-user.target" ];
}
