# Bitwarden CLI (rbw) configuration with work and private profiles
#
# Usage:
#   RBW_PROFILE=work rbw [command]    - Use work vault
#   RBW_PROFILE=private rbw [command] - Use private vault
#
# The bitwarden-fill userscript automatically selects the profile
# based on the qutebrowser profile (work/private).
{ pkgs, ... }:
{
  # Install rbw package
  home.packages = with pkgs; [
    rbw
    pinentry-gnome3
  ];

  # Work profile configuration
  xdg.configFile."rbw-work/config.json" = {
    text = builtins.toJSON {
      email = "philip.schoenholzer@apptiva.ch";
      sso_id = null;
      base_url = "https://vaultwarden.tools.apptiva.ch/";
      identity_url = null;
      ui_url = null;
      notifications_url = null;
      lock_timeout = 45000;
      sync_interval = 3600;
      pinentry = "pinentry";
      client_cert_path = null;
    };
  };

  # Private profile configuration
  xdg.configFile."rbw-private/config.json" = {
    text = builtins.toJSON {
      email = "phi.sch@hotmail.ch";
      sso_id = null;
      base_url = "https://vault.bitwarden.eu/";
      identity_url = null;
      ui_url = null;
      notifications_url = null;
      lock_timeout = 45000;
      sync_interval = 3600;
      pinentry = "pinentry";
      client_cert_path = null;
    };
  };
}
