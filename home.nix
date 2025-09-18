inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  tableplusAppImage = pkgs.fetchurl {
    url = "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage";
    sha256 = "02104v34p84yn1fpqy0pcy12b5a1vi1drb4sfarcq8d9da8hywp0";
  };

  tableplusEnv = pkgs.writeShellScriptBin "tableplus" ''
    exec ${pkgs.appimage-run}/bin/appimage-run ${tableplusAppImage} "$@"
  '';

  kdriveAppImage = pkgs.fetchurl {
    url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-3.7.5.20250812-amd64.AppImage";
    sha256 = "1l54a0gzi499d3zgq4v9wrp7497n440sibv0dgycm3li3hqi2nya";
  };
  kdriveEnv = pkgs.writeShellScriptBin "kdrive" ''
    # Force X11 so Qt doesn’t explode under Wayland/Hyprland
    export XDG_SESSION_TYPE=x11
    export QT_QPA_PLATFORM=xcb
    unset WAYLAND_DISPLAY
    unset SESSION_MANAGER

    exec ${pkgs.appimage-run}/bin/appimage-run ${kdriveAppImage} "$@"
  '';
in {
  imports = [
    (import ./waybar.nix inputs)
    (import ./bindings.nix inputs)
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
      tableplusEnv
      kchat
      kdriveEnv
      gcr
      ente-auth
      poedit
      morgen
      gnome-calculator
      wofi-emoji
      wlvncc
    ];
  };

  home.file = {
    "repo-preview.sh" = {
      source = ./repo-preview.sh;
      executable = true;
    };
    "vnc-mac-mini-auth.sh" = {
      source = ./vnc-mac-mini-auth.sh;
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
      tableplus = "appimage-run ~/Applications/TablePlus-x64.AppImage";
      tp = "tableplus";
    };
  };

  programs.ssh = {
    enable = true;
    includes = ["~/.colima/ssh_config"];

    matchBlocks = {
      "Github" = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_rsa";
      };
      "Bitbucket" = {
        host = "bitbucket.org";
        hostname = "bitbucket.org";
        user = "git";
        identityFile = "~/.ssh/id_rsa_bb";
      };
      "Infomaniak" = {
        host = "phischer";
        hostname = "91.214.190.25";
        user = "debian";
        identityFile = "~/.ssh/id_rsa_infomaniak";
        forwardAgent = true;
      };
      "MacMini" = {
        host = "macmini";
        hostname = "192.168.1.65";
        user = "philip";
        identityFile = "~/.ssh/id_ed25519_macmini";
        forwardAgent = true;
      };
      "Default" = {
        host = "*";
        extraOptions = {
          IgnoreUnknown = "AddKeysToAgent,UseKeychain";
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
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
    tableplus = {
      name = "TablePlus";
      exec = "tableplus";
      icon = "${config.home.homeDirectory}/.local/share/icons/tableplus.png";
      categories = ["Development" "Database"];
      type = "Application";
    };
    kdrive = {
      name = "kDrive";
      comment = "kDrive cloud sync client";
      exec = "kdrive";
      icon = "${config.home.homeDirectory}/.local/share/icons/kdrive.svg"; # put an icon here if you want
      categories = ["Network" "FileTransfer"];
      terminal = false;
    };
    wlvncc = {
      name = "VNC";
      comment = "Remote Desktop to MacMini";
      # exec = "vncmacmini";
      exec = "wlvncc -A ${config.home.homeDirectory}/vnc-mac-mini-auth.sh 192.168.1.65";
    };
  };

  wayland.windowManager.hyprland.settings = {
    "$passwordManager" = "bitwarden";
    "$messenger" = "slack";

    input = {
      kb_layout = "us";
      kb_variant = "altgr-intl";
      left_handed = true;
      natural_scroll = true;
      accel_profile = "adaptive";
      sensitivity = -0.1; # -1.0 - 1.0, 0 means no modification.
      force_no_accel = 0;
    };

    animations = {
      enabled = true; # yes, please :)

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 2, default, slide"
      ];
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
