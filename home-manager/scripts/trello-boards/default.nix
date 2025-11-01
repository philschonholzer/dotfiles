{pkgs, ...}: {
  home.file = {
    "fetch-trello-boards.sh" = {
      source = ./fetch-boards.sh;
      executable = true;
    };

    "open-trello-board" = {
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        board=$(~/fetch-trello-boards.sh 2>&1 | fuzzel -d --with-nth=1 --accept-nth=2)

        if [ $? -ne 0 ] || [ -z "$board" ]; then
          exit 1
        fi

        exec ${pkgs.chromium}/bin/chromium \
          --profile-directory="Work" \
          --app="$board" \
          --class="trello-board" \
          "$@"
      '';
      executable = true;
    };
  };

  programs.zsh.shellAliases = {
    tb = "~/open-trello-board";
  };
}
