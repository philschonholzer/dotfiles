{ ... }:
{
  flake.modules.homeManager.nixos =
    { pkgs, config, ... }:
    let
      kdriveLib = pkgs.writeShellScript "kdrive-lib" (builtins.readFile ./kdrive-lib.sh);

      mkNautilusScript = name: src: {
        "${config.home.homeDirectory}/.local/share/nautilus/scripts/${name}" = {
          source = pkgs.writeShellScript name ''
            export PATH="${
              pkgs.lib.makeBinPath [
                pkgs.wl-clipboard
                pkgs.libnotify
                pkgs.curl
                pkgs.jq
              ]
            }:$PATH"
            export KDRIVE_LIB="${kdriveLib}"
            ${builtins.readFile src}
          '';
          executable = true;
        };
      };
    in
    {
      home.file =
        (mkNautilusScript "Copy local relative path" ./01-copy-local-path.sh)
        // (mkNautilusScript "Copy internal kDrive link" ./02-share-kdrive-link.sh)
        // (mkNautilusScript "Copy kDrive link and path" ./03-copy-link-and-path.sh);
    };
}
