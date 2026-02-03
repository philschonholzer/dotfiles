{
  sqlit-pkg,
  pkgs,
  lib,
  ...
}:
let
  # Database drivers to include
  python = pkgs.python3;
  drivers = with python.pkgs; [
    pymysql # MySQL/MariaDB
    psycopg2 # PostgreSQL/CockroachDB/Supabase
    # Uncomment additional drivers as needed:
    # oracledb        # Oracle
    # duckdb          # DuckDB
    # clickhouse-connect # ClickHouse
  ];

  # Create PYTHONPATH entries for all drivers
  pythonPath = lib.concatMapStringsSep ":" (drv: "${drv}/${python.sitePackages}") drivers;

  # Create a wrapper that adds database drivers to PYTHONPATH
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
}
