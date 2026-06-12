{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      # This may also be a string or path to a .toml file.

      shell = {
        launch_apps_as_systemd_services = true;
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = ./wallpapers/kanagawa-blend.jpg;
      };

    };
  };
}
