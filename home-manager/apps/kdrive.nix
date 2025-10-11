{
  pkgs,
  config,
  ...
}: let
  kdriveAppImage = pkgs.fetchurl {
    url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-3.7.5.20250812-amd64.AppImage";
    sha256 = "1l54a0gzi499d3zgq4v9wrp7497n440sibv0dgycm3li3hqi2nya";
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
}
