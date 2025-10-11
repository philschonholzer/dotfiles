{lib, ...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      # Window settings
      window-padding-x = 14;
      window-padding-y = 14;
      window-padding-color = "extend";
      background-opacity = 0.95;
      window-decoration = "none";

      keybind =
        lib.mkForce [
        ];
    };
  };
}
