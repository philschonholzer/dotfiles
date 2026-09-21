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
        sha256 = "11g6grhrpgpdqzdfv5ad4mf99krx039d69qzl8m8j49nd9anpnhi";
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
