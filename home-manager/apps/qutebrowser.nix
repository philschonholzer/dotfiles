# Qutebrowser configuration with work and private profiles
#
# Usage:
#   qutebrowser-work    - Launch work profile (basedir: ~/.local/share/qutebrowser-work)
#   qutebrowser-private - Launch private profile (basedir: ~/.local/share/qutebrowser-private)
#   qutebrowser         - Default profile (basedir: ~/.local/share/qutebrowser)
#
# All profiles share the same configuration (settings, keybindings, theme).
# Each profile maintains separate:
# - Browsing history
# - Cookies and sessions
# - Bookmarks
# - Cache and downloads
{
  pkgs,
  config,
  ...
}: let
  # base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
  # Scheme name: Kanagawa
  # Scheme author: Tommaso Laurenzi (https://github.com/rebelot)
  # Template author: theova
  # Commentary: Tinted Theming: (https://github.com/tinted-theming)
  base00 = "#1f1f28";
  base01 = "#16161d";
  base02 = "#223249";
  base03 = "#54546d";
  base04 = "#727169";
  base05 = "#dcd7ba";
  base06 = "#c8c093";
  base07 = "#717c7c";
  base08 = "#c34043";
  base09 = "#ffa066";
  base0A = "#c0a36e";
  base0B = "#76946a";
  base0C = "#6a9589";
  base0D = "#7e9cd8";
  base0E = "#957fb8";
  base0F = "#d27e99";

  # Wrapper script for work profile
  # Shares config with default profile via symlink
  # Unsets Qt environment variables to avoid conflicts with other Qt applications (e.g. vicinae)
  qutebrowser-work = pkgs.writeShellScriptBin "qutebrowser-work" ''
    WORK_DIR="${config.home.homeDirectory}/.local/share/qutebrowser-work"
    DEFAULT_CONFIG="${config.home.homeDirectory}/.config/qutebrowser/config.py"

    unset QT_PLUGIN_PATH
    unset LD_LIBRARY_PATH
    exec ${pkgs.unstable.qutebrowser}/bin/qutebrowser \
      --basedir "$WORK_DIR" \
      --config-py "$DEFAULT_CONFIG" \
      --desktop-file-name qutebrowser-work \
      "$@"
  '';

  # Wrapper script for private profile
  # Shares config with default profile via symlink
  # Unsets Qt environment variables to avoid conflicts with other Qt applications (e.g. vicinae)
  qutebrowser-private = pkgs.writeShellScriptBin "qutebrowser-private" ''
    PRIVATE_DIR="${config.home.homeDirectory}/.local/share/qutebrowser-private"
    DEFAULT_CONFIG="${config.home.homeDirectory}/.config/qutebrowser/config.py"

    unset QT_PLUGIN_PATH
    unset LD_LIBRARY_PATH
    exec ${pkgs.unstable.qutebrowser}/bin/qutebrowser \
      --basedir "$PRIVATE_DIR" \
      --config-py "$DEFAULT_CONFIG" \
      --desktop-file-name qutebrowser-private \
      "$@"
  '';
  # Bitwarden credential filler userscript
  bitwarden-fill = pkgs.writeShellApplication {
    name = "bitwarden-fill";
    runtimeInputs = with pkgs; [
      rbw
      gnugrep
      gawk
      gnused
      coreutils
      fuzzel
    ];
    text = builtins.readFile ./bitwarden-fill.sh;
  };
  # Wrapper for default qutebrowser that unsets Qt environment variables
  # This prevents conflicts with other Qt applications (e.g. vicinae using Qt 6.10.0
  # vs qutebrowser's Qt 6.10.1) which set QT_PLUGIN_PATH and LD_LIBRARY_PATH
  qutebrowser-wrapped = pkgs.symlinkJoin {
    name = "qutebrowser-wrapped";
    paths = [pkgs.unstable.qutebrowser];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/qutebrowser \
        --unset QT_PLUGIN_PATH \
        --unset LD_LIBRARY_PATH
    '';
  };
in {
  programs.qutebrowser = {
    enable = true;
    package = qutebrowser-wrapped;
    extraConfig = ''
      c.tabs.padding = {'top': 8, 'bottom': 8, 'right': 16, 'left': 16}

      # Auto-enter passthrough mode for Missive
      config.set('input.mode_override', 'passthrough', 'mail.missiveapp.com')

      # Auto-enter passthrough mode for Trello
      config.set('input.mode_override', 'passthrough', 'trello.com')

      # Allow notifications for web apps
      config.set('content.notifications.enabled', True, 'mail.missiveapp.com')
      config.set('content.notifications.enabled', True, 'trello.com')
      config.set('content.notifications.enabled', True, 'voice.google.com')
      config.set('content.notifications.enabled', True, 'web.whatsapp.com')

      # Allow audio recording
      config.set('content.media.audio_capture', True, 'voice.google.com')
      # Allow audio and video recording
      config.set('content.media.audio_video_capture', True, 'web.whatsapp.com')

      # Darkmode for Google Apps
      config.set('colors.webpage.darkmode.enabled', True, '*.google.com')
    '';
    keyBindings.normal = {
      "H" = "tab-prev";
      "L" = "tab-next";
      "J" = "back";
      "K" = "forward";
      "l" = "jseval -q window.scrollBy({top: -400, left: 0, behavior: 'smooth'});";
      "h" = "jseval -q window.scrollBy({top: 400, left: 0, behavior: 'smooth'});";
      ",l" = "spawn --userscript ${bitwarden-fill}/bin/bitwarden-fill";
      ",u" = "spawn --userscript ${bitwarden-fill}/bin/bitwarden-fill username";
      ",p" = "spawn --userscript ${bitwarden-fill}/bin/bitwarden-fill password";
    };
    settings = {
      tabs = {
        show = "multiple";
        indicator.width = 3;
        favicons.scale = 0.9;
      };

      fonts.tabs.selected = "11pt";
      fonts.tabs.unselected = "11pt";

      statusbar.show = "in-mode";

      # Enable smooth scrolling
      scrolling.smooth = true;

      downloads.location.directory = "${config.home.homeDirectory}/Downloads/";

      editor.command = ["nvim" "{file}"];

      messages.timeout = 9000;

      colors = {
        webpage.preferred_color_scheme = "dark";

        # Completion widget
        completion = {
          fg = base05;
          odd.bg = base01;
          even.bg = base00;
          category = {
            fg = base0A;
            bg = base00;
            border = {
              top = base00;
              bottom = base00;
            };
          };
          item = {
            selected = {
              fg = base05;
              bg = base02;
              border = {
                top = base02;
                bottom = base02;
              };
              match.fg = base0B;
            };
          };
          match.fg = base0B;
          scrollbar = {
            fg = base05;
            bg = base00;
          };
        };

        # Context menu
        contextmenu = {
          disabled = {
            bg = base01;
            fg = base04;
          };
          menu = {
            bg = base00;
            fg = base05;
          };
          selected = {
            bg = base02;
            fg = base05;
          };
        };

        # Download bar
        downloads = {
          bar.bg = base00;
          start = {
            fg = base00;
            bg = base0D;
          };
          stop = {
            fg = base00;
            bg = base0C;
          };
          error.fg = base08;
        };

        # Hints
        hints = {
          fg = base00;
          bg = base0A;
          match.fg = base05;
        };

        # Keyhint widget
        keyhint = {
          fg = base05;
          suffix.fg = base05;
          bg = base00;
        };

        # Messages
        messages = {
          error = {
            fg = base00;
            bg = base08;
            border = base08;
          };
          warning = {
            fg = base00;
            bg = base0E;
            border = base0E;
          };
          info = {
            fg = base05;
            bg = base00;
            border = base00;
          };
        };

        # Prompts
        prompts = {
          fg = base05;
          border = base00;
          bg = base00;
          selected = {
            bg = base02;
            fg = base05;
          };
        };

        # Statusbar
        statusbar = {
          normal = {
            fg = base0B;
            bg = base00;
          };
          insert = {
            fg = base00;
            bg = base0D;
          };
          passthrough = {
            fg = base00;
            bg = base0C;
          };
          private = {
            fg = base00;
            bg = base01;
          };
          command = {
            fg = base05;
            bg = base00;
            private = {
              fg = base05;
              bg = base00;
            };
          };
          caret = {
            fg = base00;
            bg = base0E;
            selection = {
              fg = base00;
              bg = base0D;
            };
          };
          progress.bg = base0D;
          url = {
            fg = base05;
            error.fg = base08;
            hover.fg = base05;
            success = {
              http.fg = base0C;
              https.fg = base0B;
            };
            warn.fg = base0E;
          };
        };

        # Tabs
        tabs = {
          bar.bg = base00;
          indicator = {
            start = base0D;
            stop = base0C;
            error = base08;
          };
          odd = {
            fg = base05;
            bg = base01;
          };
          even = {
            fg = base05;
            bg = base00;
          };
          pinned = {
            even = {
              bg = base0C;
              fg = base07;
            };
            odd = {
              bg = base0B;
              fg = base07;
            };
            selected = {
              even = {
                bg = base02;
                fg = base05;
              };
              odd = {
                bg = base02;
                fg = base05;
              };
            };
          };
          selected = {
            odd = {
              fg = base05;
              bg = base02;
            };
            even = {
              fg = base05;
              bg = base02;
            };
          };
        };
      };
    };
  };

  # Add wrapper scripts to PATH
  home.packages = [
    qutebrowser-work
    qutebrowser-private
  ];

  # Desktop entries for both profiles
  xdg.desktopEntries = {
    qutebrowser-work = {
      name = "Qutebrowser (Work)";
      genericName = "Web Browser - Work Profile";
      exec = "${qutebrowser-work}/bin/qutebrowser-work %u";
      terminal = false;
      categories = ["Application" "Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml"];
      icon = "qutebrowser";
    };

    qutebrowser-private = {
      name = "Qutebrowser (Private)";
      genericName = "Web Browser - Private Profile";
      exec = "${qutebrowser-private}/bin/qutebrowser-private %u";
      terminal = false;
      categories = ["Application" "Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml"];
      icon = "qutebrowser";
    };
  };
}
