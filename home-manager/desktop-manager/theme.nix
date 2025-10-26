inputs: {pkgs, ...}: {
  colorScheme = inputs.nix-colors.colorSchemes.kanagawa;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "Adwaita";
    style.name = "Adwaita-dark";
  };
}
