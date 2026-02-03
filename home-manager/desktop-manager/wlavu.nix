{ wlavu, ... }:
{
  home.packages = [ wlavu ];

  systemd.user.services.wlavu = {
    Unit = {
      Description = "Wlavu audio visualization";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${wlavu}/bin/wlavu -a right -w 2";
      Restart = "always";
      RestartSec = 3;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
