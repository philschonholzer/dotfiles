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
        sha256 = "12rjnmk6jm6bv4i1grp07dw8zyzzlp1sznqma7mirwldid73fkg8";
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
