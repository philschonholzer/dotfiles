# Home-manager Niri configuration module
# This module handles Niri configuration at the user level
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.niri;
in
{
  options.services.niri = {
    enable = lib.mkEnableOption "Niri window manager (home-manager)";

    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the machine-specific Niri config override file (should be in the machine's directory)";
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
    xdg.configFile."niri/config.kdl".text =
      let
        # Read machine-specific overrides from the provided path
        machineConfig = builtins.readFile cfg.configFile;
        # Read base configuration from niri-configs directory
        baseConfig = builtins.readFile ./niri-base.kdl;
        # Concatenate: machine-specific first (for environment block), then base
        mergedConfig = machineConfig + "\n" + baseConfig;
      in
      # Replace the default-column-width line with the configured value
      builtins.replaceStrings
        [ "default-column-width { proportion 0.5; }" ]
        [ "default-column-width { ${cfg.defaultColumnWidth}; }" ]
        mergedConfig;
  };
}
