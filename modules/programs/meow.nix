{ ... }:
{
  flake.modules.homeManager.x86_64 =
    { pkgs, ... }:
    let
      meowAppImage = pkgs.fetchurl {
        url = "https://meow.qfiber.co.il/api/v1/download/meow.AppImage";
        # Run `update-clients` and select Meow to accept the download consent, fetch the latest
        # AppImage, update this hash, format the file, stage the change, and
        # run `nix flake check`.
        sha256 = "0w8kvzp9r0kmgjf6brch0d6ca2pnrvbqxf69lrcn31mq9zg6d647";
      };

      meow = pkgs.writeShellScriptBin "meow-sip" ''
        exec ${pkgs.appimage-run}/bin/appimage-run ${meowAppImage} "$@"
      '';

    in
    {
      home.packages = [ meow ];

      xdg.desktopEntries.meow-sip = {
        name = "Meow";
        genericName = "SIP Phone";
        comment = "A modern SIP voice client";
        exec = "meow-sip %u";
        icon = "meow-sip";
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "Telephony"
        ];
        mimeType = [ "x-scheme-handler/tel" ];
      };

      xdg.mimeApps.defaultApplications."x-scheme-handler/tel" = "meow-sip.desktop";
    };
}
