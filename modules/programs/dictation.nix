{ inputs, ... }:
let
  inherit (inputs) dictation;
in
{
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = [
      dictation.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
