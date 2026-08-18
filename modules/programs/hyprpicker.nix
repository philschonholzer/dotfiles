{ ... }: {
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = [ pkgs.hyprpicker ];

    xdg.desktopEntries.hyprpicker = {
      name = "Hyprpicker";
      genericName = "Color Picker";
      comment = "Pick a color from the screen";
      exec = "hyprpicker --autocopy";
      icon = ./icons/hyprpicker.svg;
      terminal = false;
      type = "Application";
      categories = [ "Utility" ];
    };
  };
}
