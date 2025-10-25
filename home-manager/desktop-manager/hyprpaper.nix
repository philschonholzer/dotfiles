{
  home.file = {
    "Pictures/Wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Pictures/Wallpapers/nord-1.png"
      ];
      wallpaper = [
        ",~/Pictures/Wallpapers/nord-1.png"
      ];
    };
  };
}
