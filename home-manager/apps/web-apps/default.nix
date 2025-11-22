{
  pkgs,
  config,
  ...
}: let
  apps = {
    chatgpt = {
      name = "ChatGPT";
      url = "https://chat.openai.com";
      profile = "work";
      iconPath = "${./icons/chatgpt.png}";
      categories = ["Network" "Office" "Development"];
    };
    trello = {
      name = "Trello";
      url = "https://trello.com";
      profile = "work";
      iconPath = "${./icons/trello.svg}";
      categories = ["Network" "Office" "ProjectManagement"];
    };
    trello-tasks = {
      name = "Meine Tasks - Trello";
      url = "https://trello.com/v/Nqy4HPGw/philip-in-arbeit";
      profile = "work";
      iconPath = "${./icons/trello.svg}";
      categories = ["Network" "Office" "ProjectManagement"];
    };
    notion = {
      name = "Notion";
      url = "https://notion.so";
      profile = "work";
      iconPath = "${./icons/notion.png}";
      categories = ["Network" "Office"];
    };
    missive = {
      name = "Missive";
      url = "https://mail.missiveapp.com/";
      profile = "work";
      iconPath = "${./icons/missive.svg}";
      categories = ["Network" "Email"];
    };
    google-voice = {
      name = "Google Voice";
      url = "https://voice.google.com";
      profile = "work";
      iconPath = "${./icons/google-voice.svg}";
      categories = ["Network" "Telephony"];
    };
  };

  makeWebApp = class: app: {
    package = pkgs.writeShellScriptBin "webapp-${class}" ''
      DEFAULT_CONFIG="${config.home.homeDirectory}/.config/qutebrowser/config.py"

      exec ${pkgs.unstable.qutebrowser}/bin/qutebrowser \
        --basedir "${config.home.homeDirectory}/.local/share/qutebrowser-${app.profile}" \
        --config-py "$DEFAULT_CONFIG" \
        --desktop-file-name "${class}" \
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
