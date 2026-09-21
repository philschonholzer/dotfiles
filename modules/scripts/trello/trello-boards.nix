{ ... }: {
  flake.modules.homeManager.base = { pkgs, config, ... }: {
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

          DEFAULT_CONFIG="${config.home.homeDirectory}/.config/qutebrowser/config.py"

          exec ${config.programs.qutebrowser.package}/bin/qutebrowser \
            --basedir "${config.home.homeDirectory}/.local/share/qutebrowser-trello" \
            --config-py "$DEFAULT_CONFIG" \
            --set "tabs.tabs_are_windows" "true" \
            --desktop-file-name "trello" \
            --target window \
            --override-restore \
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
