{ inputs, ... }:
let
  inherit (inputs) dictation;
in {
  flake.modules.homeManager.dictation = { pkgs, ... }: (import ../home-manager/apps/dictation.nix) { pkgs = pkgs; dictation = dictation; };
}
