{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./desktop-manager
    ./apps
    ./scripts
  ];

  home = {
    username = "philip";
    homeDirectory = "/home/philip";
    stateVersion = "25.05";

    sessionVariables = {
      BROWSER = "qutebrowser-work";
      DEFAULT_BROWSER = "qutebrowser-work";
    };

    packages = with pkgs; [
      unstable.opencode
      unstable.blender
      ente-auth
      bitwarden-desktop
      telegram-desktop
      nodejs_24
      pnpm
      wl-clipboard
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      google-cloud-sql-proxy
      keymapp
      p7zip
      dbeaver-bin
      pinta
      papers
      xournalpp
      pandoc
      neofetch
      mysql84
      gcr
      poedit
      gnome-calculator
      wofi-emoji
      sushi
      handbrake
      localsend
      inkscape
      gftp
      parsec-bin
      xwayland-satellite
      jq
      alejandra
    ];
  };

  programs.alacritty.enable = true;

  # Fonts
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["JetBrainsMono Nerd Font"];
    };
  };

  # Set default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # PDF
      "application/pdf" = "org.gnome.Papers.desktop";

      # Browser
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/chrome" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-htm" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-html" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-shtml" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-xhtml" = "org.qutebrowser.qutebrowser.desktop";
      "application/x-extension-xht" = "org.qutebrowser.qutebrowser.desktop";
      "application/xhtml+xml" = "org.qutebrowser.qutebrowser.desktop";

      # Telegram
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";

      # Tel
      "x-scheme-handler/tel" = "google-voice.desktop";
    };
  };

  programs.swaylock.enable = true;
  services.mako = {
    enable = true;

    settings = {
      background-color = "#${config.colorScheme.palette.base00}";
      text-color = "#${config.colorScheme.palette.base05}";
      border-color = "#${config.colorScheme.palette.base04}";
      progress-color = "#${config.colorScheme.palette.base0D}";

      width = 420;
      height = 110;
      padding = "10";
      margin = "10";
      border-size = 2;
      border-radius = 0;

      anchor = "top-right";
      layer = "overlay";

      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      sort = "-time";

      group-by = "app-name";

      actions = true;

      format = "<b>%s</b>\\n%b";
      markup = true;
    };
  };
}
