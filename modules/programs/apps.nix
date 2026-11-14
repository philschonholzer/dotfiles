{ ... }: {
  flake.modules.nixos.base = { ... }: {
    programs = {
      mosh.enable = true;
      steam.enable = true;
      obs-studio = {
        enable = true;
        enableVirtualCamera = true;
      };
    };

    services.playerctld.enable = true;
  };
}
