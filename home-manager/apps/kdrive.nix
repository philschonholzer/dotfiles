{
  pkgs,
  config,
  ...
}: let
  kdriveAppImage = pkgs.fetchurl {
    url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-3.7.9.1-amd64.AppImage";
    sha256 = "0qiknfmw108hvrcmi1pml5ls73c3ngr2y18cnzysb9hn2hr5pc40";
  };
  kdriveEnv = pkgs.writeShellScriptBin "kdrive" ''
    # Force X11 so Qt doesn’t explode under Wayland/Hyprland
    export XDG_SESSION_TYPE=x11
    export QT_QPA_PLATFORM=xcb
    unset WAYLAND_DISPLAY
    unset SESSION_MANAGER

    exec ${pkgs.appimage-run}/bin/appimage-run ${kdriveAppImage} "$@"
  '';
in {
  home.packages = [kdriveEnv];

  xdg.desktopEntries = {
    kdrive = {
      name = "kDrive";
      comment = "kDrive cloud sync client";
      exec = "kdrive";
      icon = "${config.home.homeDirectory}/.local/share/icons/kdrive.svg"; # put an icon here if you want
      categories = ["Network" "FileTransfer"];
      terminal = false;
    };
  };

  systemd.user.services.kdrive = {
    Unit = {
      Description = "kDrive cloud sync client";
      After = ["graphical-session.target"];
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
      WantedBy = ["graphical-session.target"];
    };
  };
}
