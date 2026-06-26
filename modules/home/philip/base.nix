{ ... }: {
  flake.modules.homeManager.philip = { pkgs, ... }: {
    home = {
      username = "philip";
      homeDirectory = "/home/philip";

      sessionVariables = {
        BROWSER = "qutebrowser-work";
        DEFAULT_BROWSER = "qutebrowser-work";
      };

      packages = with pkgs; [
        unstable.opencode
        unstable.pi-coding-agent
        bitwarden-desktop
        ente-auth
        telegram-desktop
        nodejs_24
        pnpm
        wl-clipboard
        (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
        google-cloud-sql-proxy
        keymapp
        p7zip
        dbeaver-bin
        pinta
        papers
        xournalpp
        pandoc
        fastfetch
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
        jq
        unstable.gthumb
        loupe
        libreoffice
        rapidraw
        cameractrls-gtk4
        file
        gpu-screen-recorder
      ];
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "image/jpeg" = "org.gnome.gThumb.desktop";
        "image/png" = "org.gnome.gThumb.desktop";
        "image/gif" = "org.gnome.gThumb.desktop";
        "image/bmp" = "org.gnome.gThumb.desktop";
        "image/webp" = "org.gnome.gThumb.desktop";
        "image/tiff" = "org.gnome.gThumb.desktop";
        "image/svg+xml" = "org.gnome.gThumb.desktop";

        "application/pdf" = "org.gnome.Papers.desktop";

        "text/plain" = "nvim-terminal.desktop";
        "text/english" = "nvim-terminal.desktop";
        "text/x-makefile" = "nvim-terminal.desktop";
        "application/x-shellscript" = "nvim-terminal.desktop";

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

        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";

        "x-scheme-handler/tel" = "google-voice.desktop";
      };
    };
  };
}
