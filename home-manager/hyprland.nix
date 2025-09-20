inputs: {
  wayland.windowManager.hyprland.settings = {
    "$passwordManager" = "bitwarden";
    "$messenger" = "slack";

    input = {
      kb_layout = "us";
      kb_variant = "altgr-intl";
      left_handed = true;
      natural_scroll = true;
      accel_profile = "adaptive";
      sensitivity = -0.1; # -1.0 - 1.0, 0 means no modification.
      force_no_accel = 0;
    };

    animations = {
      enabled = true; # yes, please :)

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 2, default, slide"
      ];
    };
  };
}
