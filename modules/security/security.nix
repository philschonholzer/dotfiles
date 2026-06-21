{ ... }: {
  flake.modules.nixos.base = { ... }: {
    security = {
      pam = {
        services.gdm.enableGnomeKeyring = true;
        services.login.enableGnomeKeyring = true;
      };
      rtkit.enable = true;
      polkit.enable = true;
    };

    services.pcscd.enable = true;
  };
}
