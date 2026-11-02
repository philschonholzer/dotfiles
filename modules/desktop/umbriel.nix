{ inputs, ... }:
let
  inherit (inputs) umbriel;
in
{
  flake.modules.nixos.base = {
    imports = [ umbriel.nixosModules.default ];

    programs.umbriel.enable = true;
  };

  flake.modules.homeManager.base = { config, lib, ... }: {
    imports = [ umbriel.homeModules.default ];

    programs.umbriel = {
      enable = true;
      # Active settings from Umbriel's packaged examples/config.toml, with personal overrides.
      settings = {
        include.files = [ ];
        include.optional.files = [ ];

        general.autostart = [ "noctalia" ];
        input = {
          keyboard = {
            layout = "us";
            variant = "altgr-intl";
            numlock_toggle = true;
          };
          touchpad = {
            tap = false;
            disable_while_typing = true;
          };
          cursor = {
            hide_when_typing = true;
          };
        };

        overview = {
          zoom = 0.25;
        };

        # Defining this table replaces the built-in bindings.
        keybinds = {
          # Applications and session
          "Mod+D" = "spawn noctalia msg panel-toggle launcher";
          "Mod+T" = "spawn footclient";
          "Mod+W" = {
            action = "window-close";
            repeat = false;
          };
          "Mod+Escape" = "session-quit";
          "Mod+Shift+Escape" = {
            action = "shortcuts-inhibit-toggle";
            allow_when_inhibited = true;
            repeat = false;
          };

          # Change or pause an active single-source screen share.
          "Mod+X" = {
            action = "screencast-set-window";
            repeat = false;
          };
          "Mod+Shift+X" = {
            action = "screencast-set-output";
            repeat = false;
          };
          "Mod+Ctrl+X" = {
            action = "screencast-clear";
            repeat = false;
          };

          # Media, volume and brightness, including while locked
          "XF86AudioRaiseVolume" = {
            action = "spawn noctalia msg volume-up";
            allow_when_locked = true;
          };
          "XF86AudioLowerVolume" = {
            action = "spawn noctalia msg volume-down";
            allow_when_locked = true;
          };
          "XF86AudioMute" = {
            action = "spawn noctalia msg volume-mute";
            allow_when_locked = true;
            repeat = false;
          };
          "XF86AudioPlay" = {
            action = "spawn noctalia msg media toggle";
            allow_when_locked = true;
            repeat = false;
          };
          "XF86AudioNext" = {
            action = "spawn noctalia msg media next";
            allow_when_locked = true;
          };
          "XF86AudioPrev" = {
            action = "spawn noctalia msg media previous";
            allow_when_locked = true;
          };
          "XF86MonBrightnessUp" = {
            action = "spawn noctalia msg brightness-up";
            allow_when_locked = true;
          };
          "XF86MonBrightnessDown" = {
            action = "spawn noctalia msg brightness-down";
            allow_when_locked = true;
          };

          # Focus and movement
          "Mod+Left" = "window-focus-left";
          "Mod+Down" = "window-focus-down";
          "Mod+Up" = "window-focus-up";
          "Mod+Right" = "window-focus-right";
          "Mod+H" = "window-focus-left";
          "Mod+J" = "window-focus-or-workspace-down";
          "Mod+K" = "window-focus-or-workspace-up";
          "Mod+L" = "window-focus-right";
          "Mod+F1" = "window-focus-next";
          "Mod+Shift+Left" = "column-move-left";
          "Mod+Shift+Down" = "window-move-or-workspace-down";
          "Mod+Shift+Up" = "window-move-or-workspace-up";
          "Mod+Shift+Right" = "column-move-right";
          "Mod+Shift+H" = "column-move-left";
          "Mod+Shift+J" = "window-move-or-workspace-down";
          "Mod+Shift+K" = "window-move-or-workspace-up";
          "Mod+Shift+L" = "column-move-right";

          # Window state and layout
          "Mod+Shift+T" = {
            action = "window-focus-switch-floating";
            repeat = false;
          };
          "Mod+P" = {
            action = "window-toggle-pinned";
            repeat = false;
          };
          "Mod+F" = {
            action = "window-toggle-maximize";
            repeat = false;
          };
          "Mod+Shift+F" = {
            action = "window-toggle-fullscreen";
            repeat = false;
          };
          "Mod+R" = "window-cycle-primary-extent";
          "Mod+Shift+R" = "window-cycle-primary-extent-back";
          "Mod+Comma" = "window-modify-primary-extent -0.05";
          "Mod+Period" = "window-modify-primary-extent 0.05";
          "Mod+WheelUp" = "window-focus-left";
          "Mod+WheelDown" = "window-focus-right";
          "Mod+O" = {
            action = "overview-toggle";
            repeat = false;
          };

          # Workspaces
          "Mod+1" = "workspace-switch 1";
          "Mod+2" = "workspace-switch 2";
          "Mod+3" = "workspace-switch 3";
          "Mod+4" = "workspace-switch 4";
          "Mod+5" = "workspace-switch 5";
          "Mod+6" = "workspace-switch 6";
          "Mod+7" = "workspace-switch 7";
          "Mod+8" = "workspace-switch 8";
          "Mod+9" = "workspace-switch 9";
          "Mod+Shift+1" = "window-move-to-workspace 1";
          "Mod+Shift+2" = "window-move-to-workspace 2";
          "Mod+Shift+3" = "window-move-to-workspace 3";
          "Mod+Shift+4" = "window-move-to-workspace 4";
          "Mod+Shift+5" = "window-move-to-workspace 5";
          "Mod+Shift+6" = "window-move-to-workspace 6";
          "Mod+Shift+7" = "window-move-to-workspace 7";
          "Mod+Shift+8" = "window-move-to-workspace 8";
          "Mod+Shift+9" = "window-move-to-workspace 9";

          # Scratchpad
          "Mod+Shift+Space" = {
            action = "window-move-to-scratchpad";
            repeat = false;
          };
          "Mod+Space" = "scratchpad-toggle";
          "Mod+Ctrl+Space" = {
            action = "window-restore-from-scratchpad";
            repeat = false;
          };
          "Mod+Tab" = "scratchpad-focus-next";
        };

        layout = {
          gap = 5;
          extent_presets = [
            0.333
            0.5
            0.667
          ];
          scrolling.default_extent_fraction = 0.5;
        };

        window_rule = [
          { blur = true; }
          {
            match.app_id = "^dev.noctalia.Noctalia$";
            default_floating = true;
            default_floating_size_px = {
              width = 1020;
              height = 900;
            };
          }
          {
            match.app_id = "^dev.noctalia.UmbrielSharePicker$";
            default_floating = true;
            default_floating_size_px = {
              width = 800;
              height = 600;
            };
          }
          {
            match.title = "^(Picture-in-Picture|Picture in picture)$";
            default_floating = true;
            default_maximize = false;
            default_position = {
              x = 20;
              y = 20;
              anchor = "bottom_right";
            };
          }
          {
            match.title = "^notificationtoasts_.+_desktop";
            default_position = {
              x = 0;
              y = 0;
              anchor = "bottom_right";
            };
            default_focused = false;
            default_pinned = true;
          }
        ];

        layer_rule = [
          {
            match.namespace = ''^noctalia-(bar-[^"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^"]*)$'';
            blur = true;
            blur_ignore_alpha = 0.5;
            blur_popups = true;
          }
          {
            match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)$";
            blur_optimized = false;
          }
        ];

        hot_corners.top_left = {
          enabled = true;
          delay_ms = 500;
          action = "overview-open";
        };
      };
    };
  };

  flake.modules.homeManager.genericLinux =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      portal = umbriel.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-umbriel;
    in
    {
      xdg.portal = {
        enable = true;
        extraPortals = [
          portal
          pkgs.xdg-desktop-portal-gtk
        ];
        config.umbriel = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "umbriel" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "umbriel" ];
          "org.freedesktop.impl.portal.InputCapture" = [ "umbriel" ];
        };
      };

      # Fedora's session bus does not discover activation files in the Nix profile.
      xdg.dataFile."dbus-1/services/org.freedesktop.impl.portal.desktop.umbriel.service".source =
        "${portal}/share/dbus-1/services/org.freedesktop.impl.portal.desktop.umbriel.service";

      # The upstream Home Manager module does not register the session's systemd units.
      xdg.configFile =
        lib.genAttrs
          [
            "systemd/user/umbriel.service"
            "systemd/user/umbriel-session.target"
            "systemd/user/umbriel-shutdown.target"
          ]
          (name: {
            source = "${config.programs.umbriel.package}/lib/${name}";
          })
        // {
          "systemd/user/xdg-desktop-portal-umbriel.service".source =
            "${portal}/lib/systemd/user/xdg-desktop-portal-umbriel.service";

          # Fedora's frontend does not support Home Manager's portal discovery variable.
          "systemd/user/xdg-desktop-portal.service.d/override.conf".text = ''
            [Service]
            ExecStart=
            ExecStart=${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal
            Environment="NIX_XDG_DESKTOP_PORTAL_DIR=${config.home.profileDirectory}/share/xdg-desktop-portal/portals"
          '';
        };
    };

}
