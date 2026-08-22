{ inputs, ... }:
let
  inherit (inputs) noctalia;
in
{
  flake.modules.nixos.base = {
    imports = [
      inputs.noctalia-greeter.nixosModules.default
    ];
    programs = {
      noctalia-greeter.enable = true;
    };
  };
  flake.modules.homeManager.genericLinux = { pkgs, ... }: {
    programs.noctalia = {
      package = pkgs.writeShellScriptBin "noctalia" "exec /usr/bin/noctalia \"$@\"";
      validateConfig = false;
    };
  };
  flake.modules.homeManager.base = { ... }: {
    imports = [
      noctalia.homeModules.default
    ];
    xdg.configFile."noctalia/trello.json".text = builtins.toJSON {
      boards = [
        {
          board = "Apptiva-Kreis";
          list = "In Arbeit";
        }
        {
          board = "App-Entwicklung";
          list = "In Arbeit";
        }
        {
          board = "Marketing & Akquise";
          list = "In Arbeit";
        }
        {
          board = "Offerten";
          list = "Potential";
        }
        {
          board = "Suva Cycle & Slope Track";
          list = "In Umsetzung";
        }
        {
          board = "FleetAssistant";
          list = "In Arbeit";
        }
        {
          board = "Administratives";
          list = "In Arbeit";
        }
        {
          board = "Apptiva Governance";
          list = "In Arbeit";
        }
        {
          board = "injoi Produktentwicklung";
          list = "In Arbeit";
        }
      ];
    };

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        bar.default = {
          background_opacity = 0.0;
          center = [
            "clock"
            "date"
            "weather"
          ];
          end = [
            "tray"
            "spacer_2"
            "cpu"
            "ram"
            "tasks"
            "notifications"
            "clipboard"
            "bluetooth"
            "network"
            "output_volume"
            "input_volume"
            "battery"
            "control-center"
            "widget"
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
            calendars = [
              "b9bad3e4-8036-4532-aff4-c1f71aa20f67"
              "46a40440-281c-4b36-9e67-18ad062cb8f7"
              "fd7610fa-6aab-43e2-bec2-a506c2140d09"
              "2cb89fbd-36a3-454a-a994-9dcb509b5f34"
              "a4c46500-6220-43c4-ab31-68e8d3461d9d"
              "277183b3-8818-4c6b-aca0-060ff4574232"
              "2c8c27c8-aa68-4651-9b75-03441d0141b4"
              "cbebdc84-56c6-4da7-911f-617a4879c7ff"
            ];
          };
        };

        control_center = {
          width = 1040;
          calendar.show_week_numbers = true;
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
          address = "Lucerne, Switzerland";
          auto_locate = false;
        };

        idle = {
          behavior_order = [
            "screen-off"
            "idle-behavior"
          ];

          behavior."screen-off" = {
            action = "screen_off";
            enabled = true;
            timeout = 1800;
          };

          behavior."idle-behavior" = {
            action = "suspend";
            enabled = true;
            lock_before_suspend = false;
            timeout = 7200;
          };
        };

        lockscreen_widgets = {
          enabled = false;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@HDMI-A-1"
            "lockscreen-login-box@DP-2"
            "lockscreen-login-box@DP-3"
            "lockscreen-login-box@winit"
            "lockscreen-login-box@eDP-1"
          ];

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {

            "lockscreen-login-box@HDMI-A-1" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 1720.0;
              cy = 1258.0;
              output = "HDMI-A-1";
              placement_height = 0.0;
              placement_width = 0.0;
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };

            "lockscreen-login-box@DP-2" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 1920.0;
              cy = 1418.0;
              output = "DP-2";
              placement_height = 0.0;
              placement_width = 0.0;
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };

            "lockscreen-login-box@DP-3" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 1600.0;
              cy = 1227.0;
              output = "DP-3";
              placement_height = 1350.0;
              placement_width = 3200.0;
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };

            "lockscreen-login-box@eDP-1" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 756.0;
              cy = 822.0;
              output = "eDP-1";
              placement_height = 0.0;
              placement_width = 0.0;
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };

            "lockscreen-login-box@winit" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 1057.0;
              cy = 1623.0;
              output = "winit";
              placement_height = 0.0;
              placement_width = 0.0;
              rotation = 0.0;
              type = "login_box";

              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };
          };
        };

        plugins = {
          enabled = [ "philip/trello" ];

          source = [
            {
              kind = "git";
              location = "https://github.com/noctalia-dev/official-plugins";
              name = "official";
            }
            {
              kind = "git";
              location = "https://github.com/noctalia-dev/community-plugins";
              name = "community";
            }
            {
              kind = "path";
              location = "~/.local/share/noctalia/plugins/philip";
              name = "my-local-plugins";
            }
          ];
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

          session.actions = [
            {
              action = "lock";
              enabled = true;
              shortcut = "1";
              variant = "default";
            }
            {
              action = "logout";
              enabled = true;
              shortcut = "2";
              variant = "default";
            }
            {
              action = "suspend";
              enabled = true;
              shortcut = "3";
              variant = "default";
            }
            {
              action = "reboot";
              enabled = true;
              shortcut = "4";
              variant = "default";
            }
            {
              action = "shutdown";
              enabled = true;
              shortcut = "5";
              variant = "destructive";
            }
          ];
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
            community_ids = [ ];
          };
        };

        wallpaper = {
          enabled = true;
          directory = ./wallpapers;
          default.path = ./wallpapers/kanagawa-blend.jpg;
        };

        system.monitor = {
          ram_pct_activity_threshold = 75;
        };

        widget = {
          active_window = {
            icon_size = 20.0;
            max_length = 800;
          };

          cpu = {
            label_min_width = 26;
          };

          date = {
            format = "{:%a. %d. %b.}";
          };

          network = {
            show_label = false;
          };

          ram = {
            label_min_width = 62;
          };

          spacer_2 = {
            length = 32;
            type = "spacer";
          };

          tasks = {
            type = "philip/trello:tasks";
          };

          weather = {
            show_condition = false;
          };

          widget = {
            type = "yocraft/qrcode:widget";
          };

          workspaces = {
            capsule = true;
            capsule_opacity = 0.25;
            capsule_padding = 20.0;
            style = "minimal";
            label_source = "name";
            focused_color = "tertiary";
            max_label_chars = 10;
            scale = 1;
          };
        };
      };
    };
  };
}
