{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    windowrule = lib.mkForce [
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      "suppressevent maximize, class:.*"

      # Force chromium into a tile to deal with --app bug
      "tile, class:^(chromium)$"

      # Settings management
      "float, class:^(org.pulseaudio.pavucontrol|blueberry.py)$"

      # Float Steam, fullscreen RetroArch
      "float, class:^(steam)$"
      "fullscreen, class:^(com.libretro.RetroArch)$"

      # Just dash of transparency
      "opacity 0.97 0.9, class:.*"
      # Normal chrome Youtube tabs
      "opacity 1 1, class:^(chromium|google-chrome|google-chrome-unstable)$, title:.*Youtube.*"
      "opacity 1 0.97, class:^(chromium|google-chrome|google-chrome-unstable)$"
      "opacity 0.97 0.9, initialClass:^(chrome-.*-Default)$ # web apps"
      "opacity 1 1, initialClass:^(chrome-youtube.*-Default)$ # Youtube"
      "opacity 1 1, class:^(zoom|vlc|org.kde.kdenlive|com.obsproject.Studio)$"
      "opacity 1 1, class:^(com.libretro.RetroArch|steam)$"

      # Fix some dragging issues with XWayland
      "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

      # Float in the middle for clipse clipboard manager
      "float, title:(clipse)"
      "size 622 652, title:(clipse)"
      "stayfocused, title:(clipse)"

      # Slack special workspace configuration
      "workspace special:slack, class:^(Slack)$"
      "pseudo, class:^(Slack)$"
      "size 50% 90%, class:^(Slack)$"
      "float, class:^(Slack)$, title:Huddle.*"
      "pin, class:^(Slack)$, title:Huddle.*"

      "workspace special:mail, class:^(chrome-mail\.missiveapp\.com__-Work)$"
      "pseudo, class:^(chrome-mail\.missiveapp\.com__-Work)$"
      "size 50% 90%, class:^(chrome-mail\.missiveapp\.com__-Work)$"
    ];

    layerrule = [
      # Proper background blur for wofi
      "blur,wofi"
      "blur,waybar"
    ];
  };
}
