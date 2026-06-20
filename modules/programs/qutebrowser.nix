{ ... }: {
  flake.modules.homeManager.browsers = { pkgs, config, lib, ... }:
  let
    isNixOS = config.targets.genericLinux.enable == false;

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

    qutebrowserBin = if isNixOS then "${pkgs.qutebrowser}/bin/qutebrowser" else "/usr/bin/qutebrowser";

    qutebrowser-work = pkgs.writeShellScriptBin "qutebrowser-work" ''
      WORK_DIR="${config.home.homeDirectory}/.local/share/qutebrowser-work"
      DEFAULT_CONFIG="${config.home.homeDirectory}/.config/qutebrowser/config.py"

      exec ${qutebrowserBin} \
        --basedir "$WORK_DIR" \
        --config-py "$DEFAULT_CONFIG" \
        --desktop-file-name qutebrowser-work \
        "$@"
    '';

    qutebrowser-private = pkgs.writeShellScriptBin "qutebrowser-private" ''
      PRIVATE_DIR="${config.home.homeDirectory}/.local/share/qutebrowser-private"
      DEFAULT_CONFIG="${config.home.homeDirectory}/.config/qutebrowser/config.py"

      exec ${qutebrowserBin} \
        --basedir "$PRIVATE_DIR" \
        --config-py "$DEFAULT_CONFIG" \
        --desktop-file-name qutebrowser-private \
        "$@"
    '';

    bitwarden-fill = pkgs.writeShellApplication {
      name = "bitwarden-fill";
      runtimeInputs = with pkgs; [
        rbw
        jq
        gnugrep
        gawk
        gnused
        coreutils
        fuzzel
      ];
      text = builtins.readFile ../scripts/qutebrowser/bitwarden-fill.sh;
    };

    qutebrowser-wrapped =
      if isNixOS then
        pkgs.symlinkJoin {
          name = "qutebrowser-wrapped";
          paths = [ pkgs.qutebrowser ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/qutebrowser \
              --add-flags "--basedir ${config.home.homeDirectory}/.local/share/qutebrowser-work --config-py ${config.home.homeDirectory}/.config/qutebrowser/config.py"
          '';
        }
      else
        pkgs.writeShellScriptBin "qutebrowser" ''
          exec ${qutebrowserBin} \
            --basedir "${config.home.homeDirectory}/.local/share/qutebrowser-work" \
            --config-py "${config.home.homeDirectory}/.config/qutebrowser/config.py" \
            "$@"
        '';
  in
  {
    programs.qutebrowser = {
      enable = true;
      package = qutebrowser-wrapped;
      extraConfig = ''
        c.tabs.padding = {'top': 12, 'bottom': 12, 'right': 16, 'left': 16}

        config.set('input.mode_override', 'passthrough', 'mail.missiveapp.com')
        config.set('input.mode_override', 'passthrough', 'trello.com')
        config.set('input.mode_override', 'insert', 'chatgpt.com')

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
        ",d" = "set content.headers.accept_language de ;; reload";
      };
      settings = {
        tabs = {
          show = "multiple";
          indicator.width = 0;
          favicons.scale = 0.9;
          title = {
            alignment = "center";
            format = "{audio}{current_title}";
          };
        };

        fonts.tabs.selected = "11pt";
        fonts.tabs.unselected = "11pt";

        statusbar.show = "in-mode";

        scrolling.smooth = true;
        input = {
          insert_mode = {
            auto_enter = true;
            auto_leave = true;
          };
        };
        downloads = {
          location = {
            directory = "${config.home.homeDirectory}/Downloads/";
            prompt = false;
          };
          open_dispatcher = "nautilus";
        };

        editor.command = [
          "nvim"
          "{file}"
        ];

        messages.timeout = 5000;

        spellcheck.languages = [
          "en-US"
          "de-DE"
        ];

        content.pdfjs = true;

        colors = {
          webpage.preferred_color_scheme = "dark";

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

          hints = {
            fg = base00;
            bg = base0A;
            match.fg = base05;
          };

          keyhint = {
            fg = base05;
            suffix.fg = base05;
            bg = base00;
          };

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

          prompts = {
            fg = base05;
            border = base00;
            bg = base00;
            selected = {
              bg = base02;
              fg = base05;
            };
          };

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

    home.packages = [
      qutebrowser-work
      qutebrowser-private
    ];

    xdg.desktopEntries = {
      qutebrowser-work = {
        name = "Qutebrowser (Work)";
        genericName = "Web Browser - Work Profile";
        exec = "${qutebrowser-work}/bin/qutebrowser-work %u";
        terminal = false;
        categories = [
          "Application"
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "text/html"
          "text/xml"
        ];
        icon = "qutebrowser";
      };

      qutebrowser-private = {
        name = "Qutebrowser (Private)";
        genericName = "Web Browser - Private Profile";
        exec = "${qutebrowser-private}/bin/qutebrowser-private %u";
        terminal = false;
        categories = [
          "Application"
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "text/html"
          "text/xml"
        ];
        icon = "qutebrowser";
      };
    };

    xdg.dataFile = {
      "qutebrowser/qtwebengine_dictionaries".source = ./qtwebengine_dictionaries;
      "qutebrowser-work/data/qtwebengine_dictionaries".source = ./qtwebengine_dictionaries;
      "qutebrowser-private/data/qtwebengine_dictionaries".source = ./qtwebengine_dictionaries;
    };
  };
}
