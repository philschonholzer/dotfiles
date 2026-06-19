{ inputs, ... }:
let
  inherit (inputs) nix-colors;
in {
  flake.modules.homeManager.theme = { pkgs, ... }: (import ../home-manager/desktop-manager/theme.nix) { pkgs = pkgs; nix-colors = nix-colors; };
}
