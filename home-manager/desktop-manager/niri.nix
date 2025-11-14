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
      type = lib.types.path;
      description = "Path to the machine-specific Niri config override file (should be in the machine's directory)";
    };

    enableSwayidle = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable swayidle integration with Niri power management";
    };

    defaultColumnWidth = lib.mkOption {
      type = lib.types.str;
      default = "proportion 0.5";
      description = "Default column width configuration for Niri layout";
      example = "fixed 1280";
    };
  };

  config = lib.mkIf cfg.enable {
    # Generate niri config by merging base + machine-specific overrides
    xdg.configFile."niri/config.kdl".text = let
      # Read machine-specific overrides from the provided path
      machineConfig = builtins.readFile cfg.configFile;
      # Read base configuration from niri-configs directory
      baseConfig = builtins.readFile ./niri-base.kdl;
      # Concatenate: machine-specific first (for environment block), then base
      mergedConfig = machineConfig + "\n" + baseConfig;
    in
      # Replace the default-column-width line with the configured value
      builtins.replaceStrings
      ["default-column-width { proportion 0.5; }"]
      ["default-column-width { ${cfg.defaultColumnWidth}; }"]
      mergedConfig;

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
