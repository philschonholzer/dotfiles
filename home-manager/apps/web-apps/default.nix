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
  };

  makeWebApp = class: app: {
    package = pkgs.writeShellScriptBin "webapp-${class}" ''
      DEFAULT_CONFIG="${config.home.homeDirectory}/.config/qutebrowser/config.py"

      exec ${pkgs.unstable.qutebrowser}/bin/qutebrowser \
        --basedir "${config.home.homeDirectory}/.local/share/qutebrowser-${class}" \
        --config-py "$DEFAULT_CONFIG" \
        --set "tabs.tabs_are_windows" "true" \
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
in {
  home.packages = pkgs.lib.mapAttrsToList (_: app: app.package) webApps;
  xdg.desktopEntries = pkgs.lib.mapAttrs (_: app: app.desktopEntry) webApps;
}
