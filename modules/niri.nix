{ ... }: {
  flake.modules.homeManager.niri = import ../home-manager/desktop-manager/niri.nix;
}
