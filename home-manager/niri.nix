# Home-manager Niri configuration module
# This module handles Niri configuration at the user level
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.niri;
in {
  options.services.niri = {
    enable = lib.mkEnableOption "Niri window manager (home-manager)";

    configFile = lib.mkOption {
      type = lib.types.str;
      default = "niri.kdl";
      description = "Name of the Niri config file in desktop-manager/";
    };

    enableSwayidle = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable swayidle integration with Niri power management";
    };
  };

  config = lib.mkIf cfg.enable {
    # Symlink the config file
    xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/desktop-manager/${cfg.configFile}";

    # Swayidle integration with Niri
    services.swayidle = lib.mkIf cfg.enableSwayidle (let
      display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
    in {
      enable = true;
      timeouts = [
        {
          timeout = 900; # in 15 min
          command = "${pkgs.libnotify}/bin/notify-send 'Monitor off in 60 seconds' -t 60000";
        }
        {
          timeout = 960;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 990;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = display "off";
        }
        {
          event = "after-resume";
          command = display "on";
        }
      ];
    });
  };
}
