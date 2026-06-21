{ ... }: {
  flake.modules.homeManager.philip =
    { config, ... }:
    {
      xdg.desktopEntries = {
        tableplus = {
          name = "TablePlus";
          exec = "tableplus";
          icon = "${config.home.homeDirectory}/.local/share/icons/tableplus.png";
          categories = [
            "Development"
            "Database"
          ];
          type = "Application";
        };
      };
    };

  flake.modules.homeManager.x86_64 =
    { pkgs, ... }:
    let
      tableplusAppImage = pkgs.fetchurl {
        url = "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage";
        sha256 = "0db933339l91709fbrzpb8p5ybdvd71x7i1k2ifv4q862bf8n1nw";
      };

      tableplusEnv = pkgs.writeShellScriptBin "tableplus" ''
        exec ${pkgs.appimage-run}/bin/appimage-run ${tableplusAppImage} "$@"
      '';
    in
    {
      home.packages = [ tableplusEnv ];
    };

  flake.modules.homeManager.aarch64 =
    { pkgs, ... }:
    let
      tableplusAppImage = pkgs.fetchurl {
        url = "https://tableplus.com/release/linux/arm64/TablePlus-aarch64.AppImage";
        sha256 = "0b6mygwamwghrqi8lsdw9j205j8xfinqshzpk56s9k56nd8jgjcn";
      };

      tableplusEnv = pkgs.writeShellScriptBin "tableplus" ''
        exec ${pkgs.appimage-run}/bin/appimage-run ${tableplusAppImage} "$@"
      '';
    in
    {
      home.packages = [ tableplusEnv ];
    };
}
