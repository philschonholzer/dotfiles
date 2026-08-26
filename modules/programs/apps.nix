{ ... }: {
  flake.modules.nixos.base = { ... }: {
    programs = {
      calls.enable = true;
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
