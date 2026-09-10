{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      palette = config.colorScheme.palette;
    in
    {
      home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
        TERMINAL = "foot";
      };

      programs.zsh.initContent = lib.mkIf pkgs.stdenv.isLinux ''
        if [[ $TERM == foot* && -z ''${_foot_cursor_initialized-} ]]; then
          typeset -g _foot_cursor_initialized=1

          _foot_cursor() {
            case ''${KEYMAP-} in
              vicmd | visual) print -n -- $'\e[1 q' ;;
              *) print -n -- $'\e[5 q' ;;
            esac
          }

          _foot_cursor_reset() {
            print -n -- $'\e[0 q'
          }

          _foot_zle_line_init() { _foot_cursor }
          _foot_zle_keymap_select() { _foot_cursor }

          autoload -Uz add-zle-hook-widget
          add-zle-hook-widget line-init _foot_zle_line_init
          add-zle-hook-widget keymap-select _foot_zle_keymap_select

          typeset -ga preexec_functions
          preexec_functions+=(_foot_cursor_reset)
        fi
      '';

      programs.foot = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        settings = {
          main = {
            dpi-aware = "yes";
            font = "JetBrainsMono Nerd Font:size=13";
            pad = "8x8";
            selection-target = "clipboard";
          };

          cursor = {
            style = "beam";
          };

          colors-dark = {
            background = palette.base00;
            foreground = palette.base05;

            selection-foreground = palette.base00;
            selection-background = palette.base02;

            regular0 = palette.base00;
            regular1 = palette.base08;
            regular2 = palette.base0B;
            regular3 = palette.base0A;
            regular4 = palette.base0D;
            regular5 = palette.base0E;
            regular6 = palette.base0C;
            regular7 = palette.base05;

            bright0 = palette.base03;
            bright1 = palette.base08;
            bright2 = palette.base0B;
            bright3 = palette.base0A;
            bright4 = palette.base0D;
            bright5 = palette.base0E;
            bright6 = palette.base0C;
            bright7 = palette.base07;
          };

          key-bindings = {
            clipboard-paste = "Control+v";
          };
        };

        server.enable = true;
      };
    };
}
