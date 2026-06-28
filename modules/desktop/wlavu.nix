{ inputs, ... }:
let
  inherit (inputs) wlavu;
in
{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = [ wlavu.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    systemd.user.services.wlavu = {
      Unit = {
        Description = "Wlavu audio visualization";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${wlavu.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/wlavu -a right -w 2";
        Restart = "always";
        RestartSec = 3;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
