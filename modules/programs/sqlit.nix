{ inputs, ... }:
let
  inherit (inputs) sqlit;
in
{
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    let
      sqlit-pkg = sqlit.packages.${pkgs.stdenv.hostPlatform.system}.default;

      python = pkgs.python3;
      drivers = with python.pkgs; [
        pymysql
        psycopg2
      ];

      pythonPath = lib.concatMapStringsSep ":" (drv: "${drv}/${python.sitePackages}") drivers;

      sqlit-with-drivers = pkgs.symlinkJoin {
        name = "sqlit-with-drivers-${sqlit-pkg.version}";
        paths = [ sqlit-pkg ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/sqlit \
            --prefix PYTHONPATH : "${pythonPath}"
        '';
        meta = sqlit-pkg.meta // {
          description = sqlit-pkg.meta.description + " (with database drivers)";
        };
      };
    in
    {
      home.packages = [ sqlit-with-drivers ];
    };
}
