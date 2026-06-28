{ ... }: {
  flake.modules.homeManager.philip = { pkgs, ... }: {
    home = {
      username = "philip";
      homeDirectory = "/home/philip";

      sessionVariables = {
        BROWSER = "qutebrowser-work";
        DEFAULT_BROWSER = "qutebrowser-work";
      };

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
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.inkscape.inkscape.desktop";

        "application/pdf" = "org.gnome.Papers.desktop";

        "text/plain" = "nvim-terminal.desktop";
        "text/english" = "nvim-terminal.desktop";
        "text/x-makefile" = "nvim-terminal.desktop";
        "application/x-shellscript" = "nvim-terminal.desktop";

        "text/html" = "qutebrowser-work.desktop";
        "x-scheme-handler/http" = "qutebrowser-work.desktop";
        "x-scheme-handler/https" = "qutebrowser-work.desktop";
        "x-scheme-handler/about" = "qutebrowser-work.desktop";
        "x-scheme-handler/unknown" = "qutebrowser-work.desktop";
        "x-scheme-handler/chrome" = "qutebrowser-work.desktop";
        "application/x-extension-htm" = "qutebrowser-work.desktop";
        "application/x-extension-html" = "qutebrowser-work.desktop";
        "application/x-extension-shtml" = "qutebrowser-work.desktop";
        "application/x-extension-xhtml" = "qutebrowser-work.desktop";
        "application/x-extension-xht" = "qutebrowser-work.desktop";
        "application/xhtml+xml" = "qutebrowser-work.desktop";

        "video/mp4" = "org.gnome.Showtime.desktop";
        "video/x-matroska" = "org.gnome.Showtime.desktop";
        "video/webm" = "org.gnome.Showtime.desktop";
        "video/quicktime" = "org.gnome.Showtime.desktop";
        "video/x-msvideo" = "org.gnome.Showtime.desktop";
        "video/mpeg" = "org.gnome.Showtime.desktop";
        "video/ogg" = "org.gnome.Showtime.desktop";
        "video/x-flv" = "org.gnome.Showtime.desktop";
        "video/3gpp" = "org.gnome.Showtime.desktop";
        "video/3gpp2" = "org.gnome.Showtime.desktop";

        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";

        "x-scheme-handler/tel" = "google-voice.desktop";
      };
    };
  };
}
