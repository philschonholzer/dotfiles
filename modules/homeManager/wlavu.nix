{ inputs, ... }:
let
  inherit (inputs) wlavu;
in {
  flake.modules.homeManager.wlavu = { pkgs, ... }: (import ../../home-manager/desktop-manager/wlavu.nix) { wlavu = wlavu.packages.${pkgs.stdenv.hostPlatform.system}.default; };
}
