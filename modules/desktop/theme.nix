{ inputs, ... }:
let
  inherit (inputs) nix-colors;
in
{
  flake.modules.homeManager.philip = { pkgs, ... }: {
    imports = [
      nix-colors.homeManagerModules.default
    ];
    colorScheme = nix-colors.colorSchemes.kanagawa;

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk4.theme = null;
    };

    qt = {
      enable = true;
      platformTheme.name = "Adwaita";
      style.name = "Adwaita-dark";
    };

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };
}
