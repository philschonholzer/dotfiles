{ ... }:
{
  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    {
      xdg.desktopEntries.nvim-terminal = lib.mkIf pkgs.stdenv.isLinux {
        name = "Neovim (in terminal)";
        genericName = "Text Editor";
        comment = "Edit text files in Neovim within Foot terminal";
        exec = "footclient nvim %F";
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
    };
}
