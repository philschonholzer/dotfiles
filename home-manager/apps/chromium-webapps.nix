{pkgs, ...}: let
  apps = {
    chatgpt = {
      name = "ChatGPT";
      url = "https://chat.openai.com";
      profile = "Work";
      iconUrl = "https://cdn.oaistatic.com/_next/static/media/apple-touch-icon.59f2e898.png";
      iconSha256 = "024yhp9kqky0v9yviz9z60gwfqksvbx7vf8gads03idvvcja89hn";
      categories = ["Network" "Office" "Development"];
    };
    trello = {
      name = "Trello";
      url = "https://trello.com";
      profile = "Work";
      iconUrl = "https://trello.com/favicon.ico";
      iconSha256 = "0wz620krw53yqcqm8c7l9cq9yi1scnxfqndv060dpwzk0kwqnaif";
      categories = ["Network" "Office" "ProjectManagement"];
    };
    notion = {
      name = "Notion";
      url = "https://notion.so";
      profile = "Work";
      iconUrl = "https://www.notion.so/images/logo-ios.png";
      iconSha256 = "0iwvaxcwpj9k7by1zv6v1kqlnj2afxg113jrrz89vp10zl52mi2r";
      categories = ["Network" "Office"];
    };
    missive = {
      name = "Missive";
      url = "https://missiveapp.com";
      profile = "Work";
      iconUrl = "https://mail.missiveapp.com/favicon.ico";
      iconSha256 = "0axi09fb3bhp2mnmls2qrmfk4l1knm7xci6wp1jrif3qwrp73s6m";
      categories = ["Network" "Email"];
    };
  };

  makeWebApp = class: app: let
    icon = pkgs.fetchurl {
      url = app.iconUrl;
      sha256 = app.iconSha256;
    };
  in {
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
      icon = "${icon}";
      categories = app.categories;
    };
  };

  webApps = pkgs.lib.mapAttrs makeWebApp apps;
in {
  home.packages = pkgs.lib.mapAttrsToList (_: app: app.package) webApps;
  xdg.desktopEntries = pkgs.lib.mapAttrs (_: app: app.desktopEntry) webApps;
}
