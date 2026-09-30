{ ... }: {
  flake.modules.homeManager.nixos =
    { pkgs, config, ... }:
    let
      kdriveMountPoint = "${config.home.homeDirectory}/kDrive";
    in
    {
      home.packages = [ pkgs.rclone ];

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
    };

  flake.modules.homeManager.x86_64 =
    { pkgs, config, ... }:
    let
      # Run `update-clients` and select kDrive to update the client.
      # The updater stages the URL/hash change and runs nix flake check.
      # Commit pending changes to this file first, then rebuild/switch to apply the update.
      kdriveAppImage = pkgs.fetchurl {
        url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-3.8.7.1-amd64.AppImage";
        sha256 = "0yj3m8dgl1avmrh43jswm9q09lr0icbb8xnnbqqkw1lall7pyrcd";
      };
      kdrivePkg = pkgs.writeShellScriptBin "kdrive" ''
        exec ${pkgs.appimage-run}/bin/appimage-run ${kdriveAppImage} "$@"
      '';
    in
    {
      home.packages = [ kdrivePkg ];

      xdg.mime.enable = true;
      xdg.desktopEntries = {
        kdrive = {
          name = "kDrive";
          comment = "kDrive cloud sync client";
          exec = "kdrive %u";
          icon = "${config.home.homeDirectory}/.local/share/icons/kdrive.svg";
          categories = [
            "Network"
            "FileTransfer"
          ];
          mimeType = [ "x-scheme-handler/kdrive" ];
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
          ExecStart = "${kdrivePkg}/bin/kdrive";
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
    };
}
