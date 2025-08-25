{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
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
      keymapp
      lens
    ];
  };

  home.file = {
    "repo-preview.sh" = {
      source = ./repo-preview.sh;
      executable = true;
    };
  };

  programs.firefox.enable = true;

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
  ];
  services.cliphist.enable = true;
}
