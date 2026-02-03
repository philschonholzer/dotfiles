{
  pkgs,
  config,
  ...
}:
let
  qnapMountPoint = "${config.home.homeDirectory}/QNAP";
  qnapRemote = "qnap:"; # Change this to match your rclone remote name
in
{
  home.packages = [ pkgs.rclone ];

  systemd.user.services.qnap-mount = {
    Unit = {
      Description = "Mount QNAP NAS via rclone";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "exec";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${qnapMountPoint}";
      ExecStart = "${pkgs.rclone}/bin/rclone mount ${qnapRemote} ${qnapMountPoint} --vfs-cache-mode writes --config ${config.home.homeDirectory}/.config/rclone/rclone.conf";
      ExecStop = "/run/current-system/sw/bin/fusermount -u ${qnapMountPoint}";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
