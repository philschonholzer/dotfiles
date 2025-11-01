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
        # "~/Pictures/Wallpapers/nord-1.png"
        "~/Pictures/Wallpapers/kanagawa-blend.jpg"
      ];
      wallpaper = [
        ",~/Pictures/Wallpapers/kanagawa-blend.jpg"
        # ",~/Pictures/Wallpapers/nord-1.png"
      ];
    };
  };
}
