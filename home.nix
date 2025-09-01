{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  tableplusAppImage = pkgs.fetchurl {
    url = "https://tableplus.com/release/linux/x64/TablePlus-x64.AppImage";
    sha256 = "02104v34p84yn1fpqy0pcy12b5a1vi1drb4sfarcq8d9da8hywp0";
  };

  tableplusEnv = pkgs.buildFHSEnv {
    name = "tableplus";
    targetPkgs = pkgs:
      with pkgs; [
        glib
        gnutls
        libsecret
      ];
    runScript = "${pkgs.appimage-run}/bin/appimage-run ${tableplusAppImage}";
  };

  kdriveAppImage = "${config.home.homeDirectory}/Applications/kDrive-3.7.5.20250812-amd64.AppImage";
  kdriveEnv = pkgs.buildFHSEnv {
    name = "kdrive";
    targetPkgs = pkgs:
      with pkgs; [
        glib
        gnutls
        libsecret
      ];
    runScript = ''
      # Force X11 so Qt doesn’t explode under Wayland/Hyprland
      export XDG_SESSION_TYPE=x11
      export QT_QPA_PLATFORM=xcb
      unset WAYLAND_DISPLAY
      unset SESSION_MANAGER

      exec ${pkgs.appimage-run}/bin/appimage-run ${kdriveAppImage} "$@"
    '';
  };
in {
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
  services.gnome-keyring = {
    enable = true;
    # components = ["secrets" "ssh"]; # enable the Secrets API for libsecret
  };
}
