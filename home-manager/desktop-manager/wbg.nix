{pkgs, ...}: {
  home.file = {
    "Pictures/Wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };
  home.packages = [pkgs.wbg];
}
