{pkgs, ...}: let
  apps = {
    chatgpt = {
      name = "ChatGPT";
      url = "https://chat.openai.com";
      profile = "Work";
      iconPath = "${./icons/chatgpt.png}";
      categories = ["Network" "Office" "Development"];
    };
    trello = {
      name = "Trello";
      url = "https://trello.com";
      profile = "Work";
      iconPath = "${./icons/trello.svg}";
      categories = ["Network" "Office" "ProjectManagement"];
    };
    trello-tasks = {
      name = "Meine Tasks - Trello";
      url = "https://trello.com/v/Nqy4HPGw/philip-in-arbeit";
      profile = "Work";
      iconPath = "${./icons/trello.svg}";
      categories = ["Network" "Office" "ProjectManagement"];
    };
    notion = {
      name = "Notion";
      url = "https://notion.so";
      profile = "Work";
      iconPath = "${./icons/notion.png}";
      categories = ["Network" "Office"];
    };
    missive = {
      name = "Missive";
      url = "https://mail.missiveapp.com/";
      profile = "Work";
      iconPath = "${./icons/missive.svg}";
      categories = ["Network" "Email"];
    };
    google-voice = {
      name = "Google Voice";
      url = "https://voice.google.com";
      profile = "Work";
      iconPath = "${./icons/google-voice.svg}";
      categories = ["Network" "Telephony"];
    };
  };

  makeWebApp = class: app: {
    package = pkgs.writeShellScriptBin "chromium-${class}" ''
      exec ${pkgs.chromium}/bin/chromium \
        --profile-directory="${app.profile}" \
        --app="${app.url}" \
        --class="${class}" \
        "$@"
    '';
    desktopEntry = {
      name = app.name;
      exec = "chromium-${class} %U";
      icon = "${app.iconPath}";
      categories = app.categories;
    };
  };

  webApps = pkgs.lib.mapAttrs makeWebApp apps;
in {
  home.packages = pkgs.lib.mapAttrsToList (_: app: app.package) webApps;
  xdg.desktopEntries = pkgs.lib.mapAttrs (_: app: app.desktopEntry) webApps;
}
