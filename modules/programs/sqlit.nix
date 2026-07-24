{ inputs, ... }:
let
  inherit (inputs) sqlit;
in
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      sqlit-pkg = sqlit.lib.${system}.makeSqlit {
        extras = [
          "mysql"
          "postgres"
        ];
      };
    in
    {
      home.packages = [ sqlit-pkg ];
    };
}
