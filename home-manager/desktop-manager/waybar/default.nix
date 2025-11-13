{
  config,
  lib,
  nix-colors,
  ...
}: let
  palette = config.colorScheme.palette;
  convert = nix-colors.lib.conversions.hexToRGBString;
  backgroundRgb = "transparent";
  foregroundRgb = "rgb(${convert ", " palette.base05})";
  hoverRgb = "rgba(${convert ", " palette.base05},0.3)";
in {
  home.file = {
    ".config/waybar/" = {
      source = ./css;
      recursive = true;
    };
    ".config/waybar/theme.css" = {
      text = ''
        @define-color background ${backgroundRgb};
        @define-color hoverBg ${hoverRgb};
        * {
          color: ${foregroundRgb};
        }

        window#waybar .modules-left {
          margin-left: 36;
        }

        window#waybar .modules-right {
          margin-right: 36;
        }

        window#waybar {
          background-color: ${backgroundRgb};
        }

        #workspaces button.active {
          border-top: 3px solid rgba(${convert ", " palette.base05},0.5);
        }

        button:hover {
          background-color: @hoverBg
        }

      '';
    };
  };

  programs.waybar = {
    enable = true;
    settings = lib.mkForce [
      {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        spacing = 4;
        height = 36;
        modules-left = [
          "niri/workspaces"
          "custom/niri-windows"
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          # "custom/dropbox"
          "tray"
          "bluetooth"
          "network"
          "wireplumber"
          "memory"
          "cpu"
          "power-profiles-daemon"
          "battery"
        ];
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
          };
        };
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            "1" = "󰃭";
            "2" = "";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10 󰏲";
            # active = "󱓻";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
          };
        };
        "niri/window" = {
          format = "{app_id}";
        };
        "custom/niri-windows" = {
          exec = "niri-window-indicator";
          interval = 1;
          format = "{}";
          tooltip = false;
        };
        cpu = {
          interval = 5;
          format = "{usage}% ";
          on-click = "ghostty -e btop";
          max-length = 10;
        };
        memory = {
          interval = 30;
          format = "{}%  ";
          max-length = 10;
        };
        clock = {
          format = "{:%a. %d.%m. KW%V %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          tooltip = true;
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            # on-scroll-up = "tz_up";
            # on-scroll-down = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        network = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󰀂";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          nospacing = 1;
          on-click = "ghostty -e nmcli";
        };
        battery = {
          interval = 5;
          format = "{capacity}% {icon}";
          format-discharging = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon}";
          format-plugged = "";
          format-icons = {
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          format-full = "Charged ";
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
          states = {
            warning = 20;
            critical = 10;
          };
        };
        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = "blueberry";
        };
        wireplumber = {
          # Changed from "pulseaudio"
          "format" = "";
          format-muted = "󰝟";
          scroll-step = 5;
          on-click = "pwvucontrol";
          tooltip-format = "Playing at {volume}%";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; # Updated command
          max-volume = 150; # Optional: allow volume over 100%
        };
        tray = {spacing = 13;};
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            power-saver = "󰡳";
            balanced = "󰊚";
            performance = "󰡴";
          };
        };
        # "custom/dropbox" = {
        #   format = "";
        #   on-click = "nautilus ~/Dropbox";
        #   exec = "dropbox-cli status";
        #   return-type = "text";
        #   interval = 5;
        #   tooltip = true;
        #   tooltip-format = "{}";
        # };
      }
    ];
  };
}
