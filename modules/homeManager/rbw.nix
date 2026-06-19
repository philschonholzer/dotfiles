{ ... }: {
  flake.modules.homeManager.rbw = { pkgs, ... }: {
    home.packages = with pkgs; [
      rbw
      pinentry-gnome3
    ];

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
  };
}
