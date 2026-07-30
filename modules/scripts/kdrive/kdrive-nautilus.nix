{ ... }:
{
  flake.modules.homeManager.nixos =
    { pkgs, config, ... }:
    let
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
            ${builtins.readFile src}
          '';
          executable = true;
        };
      };
    in
    {
      home.file =
        (mkNautilusScript "Copy local relative path" ./01-copy-local-path.sh)
        // (mkNautilusScript "Share kDrive link" ./02-share-kdrive-link.sh);
    };
}
