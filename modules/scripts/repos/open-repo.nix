{ ... }:
{
  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    {
      home.file."open-repo" = lib.mkIf pkgs.stdenv.isLinux {
        text = ''
          if ! selection=$(
            fd -H -d 3 -t d -g '.git' ~/Projects ~/nixos-config --exec dirname |
              awk -F'/' '{short=substr($0, index($0,$5)); print short "\t" $0}' |
                noctalia dmenu -p "Open repository"
          ); then
            echo "No selection made."
            exit 1
          fi

          dir="''${selection#*$'\t'}"

          if [ -z "$dir" ]; then
            echo "No selection made."
            exit 1
          fi

          footclient --working-directory="$dir/" nvim .
        '';
        executable = true;
      };
    };
}
