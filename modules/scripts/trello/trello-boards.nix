{ ... }: {
  flake.modules.homeManager.base = { config, ... }: {
    home.file = {
      "fetch-trello-boards.sh" = {
        source = ./fetch-boards.sh;
        executable = true;
      };

      "open-trello-board" = {
        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          if ! selection=$(~/fetch-trello-boards.sh 2>&1 | noctalia dmenu -p "Trello board"); then
            exit 1
          fi

          board="''${selection#*$'\t'}"

          if [ -z "$selection" ] || [ -z "$board" ]; then
            exit 1
          fi

          exec "${config.home.profileDirectory}/bin/webapp-trello" \
            "$board" \
            "$@"
        '';
        executable = true;
      };
    };

    programs.zsh.shellAliases = {
      tb = "~/open-trello-board";
    };
  };
}
