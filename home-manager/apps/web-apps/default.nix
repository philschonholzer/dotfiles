# Web applications as Qutebrowser instances
#
# Note: webapp-google-voice has a systemd auto-restart service due to a QtWebEngine/Wayland
# crash on suspend/resume (QTBUG-86763). The crash happens when waking from suspend because
# QtWebEngine tries to update screen info before the compositor has restored outputs.
# This is hardware/timing specific and cannot be prevented at the application level.
{
  pkgs,
  config,
  ...
}: let
  apps = {
    chatgpt = {
      name = "ChatGPT";
      url = "https://chat.openai.com";
      iconPath = "${./icons/chatgpt.png}";
      categories = ["Network" "Office" "Development"];
    };
    trello = {
      name = "Trello";
      url = "https://trello.com";
      iconPath = "${./icons/trello.svg}";
      categories = ["Network" "Office" "ProjectManagement"];
    };
    trello-tasks = {
      name = "Meine Tasks - Trello";
      url = "https://trello.com/v/Nqy4HPGw/philip-in-arbeit";
      iconPath = "${./icons/trello.svg}";
      categories = ["Network" "Office" "ProjectManagement"];
    };
    notion = {
      name = "Notion";
      url = "https://notion.so";
      iconPath = "${./icons/notion.png}";
      categories = ["Network" "Office"];
    };
    missive = {
      name = "Missive";
      url = "https://mail.missiveapp.com/";
      iconPath = "${./icons/missive.svg}";
      categories = ["Network" "Email"];
    };
    google-voice = {
      name = "Google Voice";
      url = "https://voice.google.com";
      iconPath = "${./icons/google-voice.svg}";
      categories = ["Network" "Telephony"];
    };
    whats-app = {
      name = "WhatsApp";
      url = "https://web.whatsapp.com/";
      iconPath = "${./icons/whatsapp.svg}";
      categories = ["Network" "InstantMessaging" "Chat"];
    };
    deepl = {
      name = "Deepl Write";
      url = "https://www.deepl.com/de/write";
      iconPath = "${./icons/deepl-dark.svg}";
      categories = ["Utility"];
    };
    google-drive = {
      name = "Google Drive";
      url = "https://drive.google.com/drive/";
      iconPath = "${./icons/google-drive.svg}";
      categories = ["Utility"];
    };
  };

  makeWebApp = class: app: {
    package = pkgs.writeShellScriptBin "webapp-${class}" ''
      DEFAULT_CONFIG="${config.home.homeDirectory}/.config/qutebrowser/config.py"

      # Unset Qt environment variables to avoid conflicts with other Qt applications
      # (e.g. vicinae using Qt 6.10.0 vs qutebrowser's Qt 6.10.1)
      unset QT_PLUGIN_PATH
      unset LD_LIBRARY_PATH

      exec ${pkgs.unstable.qutebrowser}/bin/qutebrowser \
        --basedir "${config.home.homeDirectory}/.local/share/qutebrowser-${class}" \
        --config-py "$DEFAULT_CONFIG" \
        --set "tabs.tabs_are_windows" "true" \
        --set "content.javascript.clipboard" "access-paste" \
        --desktop-file-name "${class}" \
        --target window \
        --override-restore \
        "${app.url}" \
        "$@"
    '';
    desktopEntry = {
      name = app.name;
      exec = "webapp-${class} %U";
      icon = "${app.iconPath}";
      categories = app.categories;
    };
  };

  webApps = pkgs.lib.mapAttrs makeWebApp apps;

  # Path to qutebrowser dictionaries
  dictionaries = ../qutebrowser/qtwebengine_dictionaries;
in {
  home.packages = pkgs.lib.mapAttrsToList (_: app: app.package) webApps;
  xdg.desktopEntries = pkgs.lib.mapAttrs (_: app: app.desktopEntry) webApps;

  # Setup dictionaries for all web app qutebrowser instances
  # Using xdg.dataFile to create symlinks in the data directories
  xdg.dataFile =
    pkgs.lib.mapAttrs' (class: _: {
      name = "qutebrowser-${class}/data/qtwebengine_dictionaries";
      value.source = dictionaries;
    })
    apps;

  # Auto-restart service for webapp-google-voice
  # Workaround for QtWebEngine crash on suspend/resume due to Wayland timing issue
  # See: https://bugreports.qt.io/browse/QTBUG-86763
  systemd.user.services.webapp-google-voice = {
    Unit = {
      Description = "Google Voice Web App (Qutebrowser)";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${webApps.google-voice.package}/bin/webapp-google-voice";
      Restart = "on-failure";
      RestartSec = 5;
      # Prevent restart loop if it fails too quickly
      StartLimitBurst = 5;
      StartLimitIntervalSec = 30;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
