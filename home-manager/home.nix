inputs: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    (import ./waybar.nix inputs)
    (import ./bindings.nix inputs)
    ./ssh.nix
    ./hyprland.nix
    ./windows.nix
    ./apps
  ];

  home = {
    username = "philip";
    homeDirectory = "/home/philip";
    stateVersion = "25.05";

    packages = with pkgs; [
      unstable.opencode
      ente-auth
      bitwarden-desktop
      slack
      telegram-desktop
      nodejs_24
      pnpm
      wl-clipboard
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      google-cloud-sql-proxy
      keymapp
      lens
      p7zip
      insync
      insync-nautilus
      dbeaver-bin
      pinta
      papers
      xournalpp
      onlyoffice-desktopeditors
      pandoc
      neofetch
      mysql84
      kchat
      gcr
      ente-auth
      poedit
      morgen
      gnome-calculator
      wofi-emoji
      wlvncc
      sushi
      handbrake
      localsend
      inkscape
      gftp
    ];
  };

  home.file = {
    "repo-preview.sh" = {
      source = ./repo-preview.sh;
      executable = true;
    };
  };

  programs.firefox.enable = true;

  programs.ghostty = {
    enable = true;
    settings = {
      # Window settings
      window-padding-x = 14;
      window-padding-y = 14;
      window-padding-color = "extend";
      background-opacity = 0.95;
      window-decoration = "none";

      keybind =
        lib.mkForce [
        ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaPackages = ps: [ps.magick];
    extraPackages = with pkgs; [
      imagemagick
      websocat
      cargo
      lua
      lua-language-server
      stylua
      tinymist
      ghostscriptX
      marksman
      lsof
    ];
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        sidePanelWidth = 0.2;
      };
      git = {
        paging = {
          colorArgs = "always";
          pager = "delta --dark --paging=never --syntax-theme base16-256 -s";
        };
      };
    };
  };

  # Git
  programs.git = {
    enable = true;
    delta.enable = true;
    ignores = [
      "*~"
      ".DS_Store"
      "/.direnv"
    ];
    extraConfig = {
      core = {
        # editor = "code --wait";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.zsh = {
    enable = true;

    syntaxHighlighting = {
      enable = true;
    };

    historySubstringSearch.enable = true;

    initContent = ''
      c() {
        local dir
        dir=$(fd -H -d 3 -t d -g '.git' ~/dev ~/nixos-config --exec dirname | \
              awk -F'/' '{short=substr($0, index($0,$5)); print short "\t" $0}' | \
              fzf --with-nth=1 \
                  --preview '~/repo-preview.sh {2}' | \
              cut -f2)
        if [ -z "$dir" ]; then
          echo "No selection made."
          return 1
        fi
        cd "$dir" || return
      }
    '';

    shellAliases = {
      pn = "pnpm";
      p = "pnpm";
      mysql-proxy-apptiva = "cloud-sql-proxy kubernetes-283408:europe-west6:apptiva-mysql-8-common -p 3308";
      v = "c && vi .";
      nrs = "sudo nixos-rebuild switch";
      lg = "lazygit";
    };
  };

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/nvim";
    "hypr/xdph.conf".text = ''
      screencopy {
        allow_token_by_default = true
      }
    '';
  };

  xdg.desktopEntries = {
    wlvncc = {
      name = "VNC";
      comment = "Remote Desktop to MacMini";
      # Add a script in ~/.secrets/vnc-mac-mini-auth.sh
      #
      ##!/usr/bin/env bash
      #
      # echo -e "user\npassword"
      exec = "wlvncc -A ${config.home.homeDirectory}/.secrets/vnc-mac-mini-auth.sh 192.168.1.65";
    };
  };

  services.hypridle.settings.listener = lib.mkForce [
    {
      timeout = 300;
      on-timeout = "loginctl lock-session";
    }
    {
      timeout = 900;
      on-timeout = "systemctl suspend";
    }
  ];
  services.cliphist.enable = true;
}
