{ inputs, ... }:
{
  flake.overlays.affinity = inputs.affinity-nix.overlays.default;

  flake.modules.homeManager.x86_64 =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.affinity-v3 ];
    };
}
