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
        sha256 = "1r6zkz86k99q7krlkxj217w5mphszc3iz3y5qdd0x4aszb7jr6yw";
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
    };
}
