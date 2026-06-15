{
  pkgs,
  config,
  ...
}:
let
  kdriveAppImage = pkgs.fetchurl {
    url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-3.8.5.2-amd64.AppImage";
    sha256 = "00k4fgsbwkxvyzjk7byx9jlbcp5m07w7lz54129d3wy8w5vkprzi";
  };
  kdriveEnv = pkgs.writeShellScriptBin "kdrive" ''
    exec ${pkgs.appimage-run}/bin/appimage-run ${kdriveAppImage} "$@"
  '';
  kdriveMountPoint = "${config.home.homeDirectory}/kDrive";
in
{
  home.packages = [
    kdriveEnv
    pkgs.rclone
  ];

  xdg.desktopEntries = {
    kdrive = {
      name = "kDrive";
      comment = "kDrive cloud sync client";
      exec = "kdrive";
      icon = "${config.home.homeDirectory}/.local/share/icons/kdrive.svg"; # put an icon here if you want
      categories = [
        "Network"
        "FileTransfer"
      ];
      terminal = false;
    };
  };

  systemd.user.services.kdrive = {
    Unit = {
      Description = "kDrive cloud sync client";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${kdriveEnv}/bin/kdrive";
      Restart = "on-failure";
      RestartSec = "10s";
      Environment = [
        "XDG_SESSION_TYPE=x11"
        "QT_QPA_PLATFORM=xcb"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.kdrive-mount = {
    Unit = {
      Description = "Mount Infomaniak kDrive via rclone";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${kdriveMountPoint}";
      ExecStart = "${pkgs.rclone}/bin/rclone mount kdrive: ${kdriveMountPoint} --vfs-cache-mode writes --config ${config.home.homeDirectory}/.config/rclone/rclone.conf";
      ExecStop = "/run/current-system/sw/bin/fusermount -u ${kdriveMountPoint}";
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
