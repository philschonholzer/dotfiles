{ inputs, ... }:
let
  inherit (inputs) nix-colors;
in {
  flake.modules.homeManager.arm = { ... }: {
    home.stateVersion = "25.11";

    colorScheme = nix-colors.colorSchemes.kanagawa;

    targets.genericLinux = {
      enable = true;
      gpu.enable = false;
    };
  };
}
