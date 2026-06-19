{ ... }: {
  flake.modules.homeManager.affinity = import ../../home-manager/apps/affinity.nix;
}
