{ inputs, ... }: {
  flake.modules.homeManager.genericLinux =
    { pkgs, lib, ... }:
    let
      inherit (inputs.self.lib.nixgl { inherit pkgs lib; }) wrapGLExec;
    in
    {
      programs.ghostty.package = wrapGLExec "ghostty" "${pkgs.ghostty}/bin/ghostty" [ ];
      programs.ghostty.systemd.enable = false;
    };
  flake.modules.homeManager.philip =
    { config, ... }:
    let
      palette = config.colorScheme.palette;
    in
    {
      xdg.desktopEntries.nvim-terminal = {
        name = "Neovim (in terminal)";
        genericName = "Text Editor";
        comment = "Edit text files in Neovim within Ghostty terminal";
        exec = "ghostty -e nvim %F";
        icon = "nvim";
        terminal = false;
        type = "Application";
        categories = [
          "Utility"
          "TextEditor"
        ];
        mimeType = [
          "text/plain"
          "text/english"
          "text/x-makefile"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-chdr"
          "text/x-csrc"
          "text/x-java"
          "text/x-moc"
          "text/x-pascal"
          "text/x-tex"
          "application/x-shellscript"
          "text/x-c"
          "text/x-c++"
        ];
      };
      programs.ghostty = {
        enable = true;

        settings = {
          window-padding-x = 14;
          window-padding-y = 14;
          window-padding-color = "extend";
          background-opacity = 0.95;
          window-decoration = "none";
          font-family = "Liberation Sans 11";
          font-size = 12;

          copy-on-select = "clipboard";
          app-notifications = "no-clipboard-copy";
          keybind = [
            "ctrl+v=paste_from_clipboard"

            "ctrl+enter=unbind"

            "ctrl+shift+space=activate_key_table:vim"

            "ctrl+shift+e=write_scrollback_file:open"

            "vim/j=scroll_page_lines:1"
            "vim/k=scroll_page_lines:-1"
            "vim/d=scroll_page_fractional:0.5"
            "vim/u=scroll_page_fractional:-0.5"
            "vim/ctrl+f=scroll_page_down"
            "vim/ctrl+b=scroll_page_up"
            "vim/g>g=scroll_to_top"
            "vim/shift+g=scroll_to_bottom"

            "vim/q=deactivate_key_table"
            "vim/escape=deactivate_key_table"

            "vim/ctrl+shift+e=write_scrollback_file:open"

            "vim/slash=start_search"
            "vim/n=navigate_search:next"

            "vim/v=copy_to_clipboard"
            "vim/y=copy_to_clipboard"

            "vim/shift+semicolon=toggle_command_palette"
          ];

          theme = "myconfig";
        };
        themes = {
          myconfig = {
            background = "#${palette.base00}";
            foreground = "#${palette.base05}";

            selection-background = "#${palette.base02}";
            selection-foreground = "#${palette.base00}";
            palette = [
              "0=#${palette.base00}"
              "1=#${palette.base08}"
              "2=#${palette.base0B}"
              "3=#${palette.base0A}"
              "4=#${palette.base0D}"
              "5=#${palette.base0E}"
              "6=#${palette.base0C}"
              "7=#${palette.base05}"
              "8=#${palette.base03}"
              "9=#${palette.base08}"
              "10=#${palette.base0B}"
              "11=#${palette.base0A}"
              "12=#${palette.base0D}"
              "13=#${palette.base0E}"
              "14=#${palette.base0C}"
              "15=#${palette.base07}"
              "16=#${palette.base09}"
              "17=#${palette.base0F}"
              "18=#${palette.base01}"
              "19=#${palette.base02}"
              "20=#${palette.base04}"
              "21=#${palette.base06}"
            ];
          };
        };

      };
    };
}
