{
  pkgs,
  config,
  ...
}: let
  tableplusAppImage = pkgs.fetchurl {
    url = "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage";
    sha256 = "02104v34p84yn1fpqy0pcy12b5a1vi1drb4sfarcq8d9da8hywp0";
  };

  tableplusEnv = pkgs.writeShellScriptBin "tableplus" ''
    exec ${pkgs.appimage-run}/bin/appimage-run ${tableplusAppImage} "$@"
  '';
in {
  home.packages = [tableplusEnv];
  xdg.desktopEntries = {
    tableplus = {
      name = "TablePlus";
      exec = "tableplus";
      icon = "${config.home.homeDirectory}/.local/share/icons/tableplus.png";
      categories = ["Development" "Database"];
      type = "Application";
    };
  };
}
