{ inputs, ... }:
let
  inherit (inputs) dictation;
in {
  flake.modules.homeManager.dictation = { pkgs, ... }: {
    home.packages = [
      dictation.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
