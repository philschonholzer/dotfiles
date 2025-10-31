{
  pkgs,
  config,
  ...
}: let
  tableplusAppImage = pkgs.fetchurl {
    url = "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage";
    sha256 = "19dlzqqqgx1gn58ryf10qkhqf4pm82j811ws9n36r73h7dv0b8yy";
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
