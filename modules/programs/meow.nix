{ ... }:
{
  flake.modules.homeManager.x86_64 =
    { pkgs, ... }:
    let
      meowAppImage = pkgs.fetchurl {
        url = "https://meow.qfiber.co.il/api/v1/download/meow.AppImage";
        # Run `update-meow` to accept the download consent, fetch the latest
        # AppImage, update this hash, format the file, stage the change, and
        # run `nix flake check`.
        sha256 = "0sh5j34l2vmp34fk5qz1xsnpmcdrcl40mm6wi97vr9msigbi9lry";
      };

      meow = pkgs.writeShellScriptBin "meow-sip" ''
        exec ${pkgs.appimage-run}/bin/appimage-run ${meowAppImage} "$@"
      '';

      updateMeow = pkgs.writeShellApplication {
        name = "update-meow";
        runtimeInputs = with pkgs; [
          curl
          coreutils
          git
          nix
          nixfmt
          gnused
        ];
        text = builtins.readFile ./update-meow.sh;
      };
    in
    {
      home.packages = [
        meow
        updateMeow
      ];

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
