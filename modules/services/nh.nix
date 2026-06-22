{ ... }: {
  flake.modules.nixos.base = { pkgs, config, ... }: {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 5";
      flake = "/home/philip/nixos-config/"; # sets NH_OS_FLAKE variable for you
    };
  };
}
