{ inputs, ... }:
let
  inherit (inputs) noctalia;
in {
  flake.modules.homeManager.desktop = { pkgs, config, lib, ... }:
  let
    isNixOS = config.targets.genericLinux.enable == false;
    isFedora = !isNixOS && pkgs.stdenv.isLinux;
  in
  {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      package = lib.mkIf isFedora (pkgs.writeShellScriptBin "noctalia" "exec /usr/bin/noctalia \"$@\"");

      validateConfig = !isFedora;

      settings = {
        bar.default = {
          background_opacity = 0.0;
          center = [
            "date"
            "clock"
          ];
          end = [
            "cpu"
            "ram"
            "tray"
            "notifications"
            "clipboard"
            "bluetooth"
            "network"
            "output_volume"
            "input_volume"
            "battery"
            "control-center"
          ];
          margin_edge = 2;
          margin_ends = 42;
          shadow = false;
          start = [
            "workspaces"
            "active_window"
          ];
          thickness = 38;
          widget_spacing = 16;
        };

        calendar = {
          enabled = true;

          account.kdrive_private = {
            name = "Privat";
            provider = "custom";
            server_url = "https://sync.infomaniak.com/calendars/PS07330/594a7168-6b8f-4e67-a422-8bf9b01e136b";
            type = "caldav";
            username = "PS07330";
          };
          account.kdrive_work = {
            name = "Work";
            provider = "custom";
            server_url = "https://sync.infomaniak.com/calendars/PS07960/b9bad3e4-8036-4532-aff4-c1f71aa20f67";
            type = "caldav";
            username = "PS07960";
          };
        };

        desktop_widgets = {
          schema_version = 2;
          widget_order = [ "desktop-widget-0000000000000001" ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget."desktop-widget-0000000000000001" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1232.0;
            cy = 138.5;
            output = "eDP-1";
            rotation = 0.0;
            type = "weather";

            settings = {
              background_opacity = 0.42;
              background_padding = 20.0;
              background_radius = 14.0;
            };
          };
        };

        location = {
          auto_locate = true;
        };

        lockscreen_widgets = {
          enabled = false;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@winit"
            "lockscreen-login-box@eDP-1"
          ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget."lockscreen-login-box@DP-3" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1600.0;
            cy = 1227.0;
            output = "DP-3";
            rotation = 0.0;
            type = "login_box";

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };

          widget."lockscreen-login-box@eDP-1" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 756.0;
            cy = 822.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "login_box";

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };

          widget."lockscreen-login-box@winit" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1057.0;
            cy = 1623.0;
            output = "winit";
            rotation = 0.0;
            type = "login_box";

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };
        };

        plugins = {
          enabled = [ ];
        };

        shell = {
          avatar_path = ./avatar/philip.jpg;
          launch_apps_as_systemd_services = true;
          polkit_agent = true;
          telemetry_enabled = true;

          panel = {
            control_center_placement = "floating";
            transparency_mode = "soft";
          };
        };

        theme = {
          builtin = "Kanagawa";
          mode = "dark";
          source = "builtin";

          templates = {
            builtin_ids = [
              "btop"
              "gtk3"
              "gtk4"
              "ghostty"
              "qt"
            ];
            community_ids = [ "fuzzel" ];
          };
        };

        wallpaper = {
          enabled = true;
          directory = ./wallpapers;
          default.path = ./wallpapers/kanagawa-blend.jpg;
        };

        widget = {
          active_window = {
            icon_size = 20.0;
            max_length = 300;
          };

          cat = {
            type = "noctalia/bongocat:cat";
          };

          cpu = {
            label_min_width = 26;
          };

          date = {
            format = "{:%a. %d.%m.}";
          };

          network = {
            show_label = false;
          };

          ram = {
            label_min_width = 62;
          };

          workspaces = {
            capsule = true;
            capsule_opacity = 0.25;
            capsule_padding = 14.0;
            display = "name";
            focused_color = "tertiary";
            max_label_chars = 10;
            minimal = true;
            scale = 1.15;
          };
        };
      };
    };
  };
}
