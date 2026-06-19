{ ... }: {
  flake.modules.homeManager.ghostty = import ../home-manager/apps/ghostty.nix;
}
