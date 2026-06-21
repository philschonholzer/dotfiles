{ inputs, ... }:
let
  inherit (inputs) dictation;
in {
  flake.modules.homeManager.philip = { pkgs, ... }: {
    home.packages = [
      dictation.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
