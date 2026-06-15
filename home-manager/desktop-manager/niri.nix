# Home-manager Niri configuration module
# This module handles Niri configuration at the user level
{
  config,
  lib,
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
  };

  config = lib.mkIf cfg.enable {
    # Write base config and machine-specific config as separate files.
    # Machine-specific files use `include "niri-base.kdl"` to pull in the base.
    xdg.configFile = {
      "niri/config.kdl".text = builtins.readFile cfg.configFile;

      "niri/niri-base.kdl".text = builtins.readFile ./niri-base.kdl;
    };
  };
}
