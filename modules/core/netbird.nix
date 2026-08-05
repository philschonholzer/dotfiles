{ ... }: {
  flake.modules.nixos.base = { pkgs, ... }: {
    services.netbird = {
      enable = true;
    };
  };
}
