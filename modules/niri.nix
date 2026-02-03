# NixOS system-level Niri configuration module
# This module handles Niri window manager integration at the system level
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
    enable = lib.mkEnableOption "Niri window manager";

    enableSystemIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable system-level Niri integration (greetd, environment variables)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable Niri program
    programs.niri.enable = true;

    # Set environment variables for Niri session
    environment.sessionVariables = lib.mkIf cfg.enableSystemIntegration {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "niri";
    };

    # Configure greetd to use Niri
    services.greetd = lib.mkIf (cfg.enableSystemIntegration && config.services.greetd.enable) {
      settings.default_session.command = lib.mkForce "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome To NixOS' --asterisks --remember --remember-user-session --time --sessions ${pkgs.niri}/share/wayland-sessions";
    };
  };
}
