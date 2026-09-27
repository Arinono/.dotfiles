{
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}: {
  home.packages = lib.mkIf (!isDarwin) [pkgs.syncthing];

  systemd.user.services.syncthing = lib.mkIf (!isDarwin) {
    Unit = {
      Description = "Syncthing file synchronization service";
      Documentation = "man:syncthing(1)";
      After = ["network.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.syncthing}/bin/syncthing --no-browser --gui-address=0.0.0.0:8384";
      Restart = "on-failure";
      RestartSec = 5;
      SuccessExitStatus = "3 4";
      RestartForceExitStatus = "3 4";
      Environment = [
        "XDG_STATE_HOME=${config.xdg.stateHome}"
      ];
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
