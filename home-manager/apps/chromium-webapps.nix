{pkgs, ...}: let
  makeWebApp = {name, url, profile, class}:
    pkgs.writeShellScriptBin "chromium-${class}" ''
      exec ${pkgs.chromium}/bin/chromium \
        --profile-directory="${profile}" \
        --app="${url}" \
        --class="${class}" \
        "$@"
    '';

  chatgptIcon = pkgs.fetchurl {
    url = "https://cdn.oaistatic.com/_next/static/media/apple-touch-icon.59f2e898.png";
    sha256 = "024yhp9kqky0v9yviz9z60gwfqksvbx7vf8gads03idvvcja89hn";
  };

  trelloIcon = pkgs.fetchurl {
    url = "https://trello.com/favicon.ico";
    sha256 = "0wz620krw53yqcqm8c7l9cq9yi1scnxfqndv060dpwzk0kwqnaif";
  };

  notionIcon = pkgs.fetchurl {
    url = "https://www.notion.so/images/logo-ios.png";
    sha256 = "0iwvaxcwpj9k7by1zv6v1kqlnj2afxg113jrrz89vp10zl52mi2r";
  };

  missiveIcon = pkgs.fetchurl {
    url = "https://mail.missiveapp.com/favicon.ico";
    sha256 = "0axi09fb3bhp2mnmls2qrmfk4l1knm7xci6wp1jrif3qwrp73s6m";
  };
in {
  home.packages = [
    (makeWebApp {
      name = "ChatGPT";
      url = "https://chat.openai.com";
      profile = "Work";
      class = "chatgpt";
    })
    (makeWebApp {
      name = "Trello";
      url = "https://trello.com";
      profile = "Work";
      class = "trello";
    })
    (makeWebApp {
      name = "Notion";
      url = "https://notion.so";
      profile = "Work";
      class = "notion";
    })
    (makeWebApp {
      name = "Missive";
      url = "https://missiveapp.com";
      profile = "Work";
      class = "missive";
    })
  ];

  xdg.desktopEntries = {
    chatgpt = {
      name = "ChatGPT";
      exec = "chromium-chatgpt %U";
      icon = "${chatgptIcon}";
      categories = ["Network" "Office" "Development"];
      startupWMClass = "chatgpt";
    };
    trello = {
      name = "Trello";
      exec = "chromium-trello %U";
      icon = "${trelloIcon}";
      categories = ["Network" "Office" "ProjectManagement"];
      startupWMClass = "trello";
    };
    notion = {
      name = "Notion";
      exec = "chromium-notion %U";
      icon = "${notionIcon}";
      categories = ["Network" "Office"];
      startupWMClass = "notion";
    };
    missive = {
      name = "Missive";
      exec = "chromium-missive %U";
      icon = "${missiveIcon}";
      categories = ["Network" "Email"];
      startupWMClass = "missive";
    };
  };
}
