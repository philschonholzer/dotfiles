{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optional (inputs.artcraft.packages ? ${pkgs.stdenv.hostPlatform.system}) (
        inputs.artcraft.packages.${pkgs.stdenv.hostPlatform.system}.figcraft
      );
    };
}
