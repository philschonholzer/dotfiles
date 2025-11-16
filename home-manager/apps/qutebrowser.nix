{pkgs, ...}: let
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
in {
  programs.qutebrowser = {
    enable = true;
    package = pkgs.unstable.qutebrowser;
    extraConfig = ''
      c.tabs.padding = {'top': 8, 'bottom': 8, 'right': 16, 'left': 16}
    '';
    keyBindings.normal = {
      "H" = "tab-prev";
      "L" = "tab-next";
      "J" = "back";
      "K" = "forward";
    };
    settings = {
      tabs.indicator.width = 3;
      tabs.favicons.scale = 0.9;

      fonts.tabs.selected = "11pt";
      fonts.tabs.unselected = "11pt";

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
}
