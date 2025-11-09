{pkgs, ...}: {
  home.file = {
    "Pictures/Wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };

  home.packages = [pkgs.swaybg];

  systemd.user.services.swaybg = {
    Unit = {
      Description = "swaybg wallpaper";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
      Requisite = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i /home/philip/Pictures/Wallpapers/kanagawa-blend.jpg";
      Restart = "always";
    };

    # Install = {
    #   WantedBy = ["graphical-session.target"];
    # };
  };
}
