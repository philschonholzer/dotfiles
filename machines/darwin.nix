{pkgs, ...}: {
  imports = [
    ../home-manager/apps/nvim.nix
    # ../home-manager/scripts
  ];
  # Test
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "philip";
  home.homeDirectory = "/Users/philip";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [
      "JetBrainsMono Nerd Font"
    ];
  };
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    unstable.opencode
    docker-client
    colima
    raycast
    keeweb
    lens
    bun
    nodejs_24
    devenv
    ghc
    wget
    google-cloud-sql-proxy
    pnpm
    biome
    gnused
    nixpkgs-fmt
    alejandra
    lazydocker
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    nerd-fonts.jetbrains-mono
    glow
    superfile
    typst
    typstyle
    mosh
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    # "/Library/Keyboard Layouts/altgr-wr.icns".source = ./altgr-weur/altgr-weur.icns;
    # "/Library/Keyboard Layouts/altgr-wr.keylayout".source = ./altgr-weur/altgr-weur.keylayout;
    ".config/ghostty/config".text = ''
      font-family = JetBrainsMono Nerd Font Mono
      font-size = 16
      theme = Kanagawa Wave
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/philip/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    PROMPT = "$ ";
    # RPROMPT = "%~";
  };

  # programs.ghostty = {
  #   enable = true;
  #   settings = {
  #     font-family = "JetBrainsMono Nerd Font Mono";
  #     font-size = 16;
  #     theme = "Kanagawa Wave";
  #   };
  # };

  programs.kitty = {
    enable = true;
    keybindings = {
      "cmd+Enter" = "new_window_with_cwd";
      "cmd+t" = "new_tab_with_cwd";
    };
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 16;
    };
    themeFile = "kanagawa";
    settings = {
      cursor_trail = 20;
    };
  };

  programs.fzf.enable = true;
  programs.fd.enable = true;
  programs.ripgrep.enable = true;
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

  programs.yazi = {
    enable = true;
    keymap = {
      manager.preprend_keymap = [
        {
          run = ''
            shell 'qlmanage -p "$@"' --confirm
          '';
          on = ["<C-p>"];
        }
      ];
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Monokai Extended";
    };
  };

  # Git
  programs.git = {
    enable = true;
    delta.enable = true;
    userEmail = "philip.schoenholzer@apptiva.ch";
    userName = "Philip Schönholzer";
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

  # Direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    syntaxHighlighting = {
      enable = true;
    };

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    initContent = ''
      c() {
        local dir
        dir=$(fd -H -d 3 -t d -g '.git' ~/Development ~/.config --exec dirname | \
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

      source ~/completion-for-pnpm.zsh
    '';

    shellAliases = {
      pn = "pnpm";
      p = "pnpm";
      mysql-proxy-apptiva = "cloud-sql-proxy kubernetes-283408:europe-west6:apptiva-mysql-8-common -p 3308";
      flake-init = "nix flake init --template github:the-nix-way/dev-templates#empty";
      v = "c && vi .";
      hms = "home-manager switch";
      hme = "home-manager edit";
      lg = "lazygit";
    };

    # initExtra = "[ -f ~/.config/tabtab/zsh/__tabtab.zsh ] && . ~/.config/tabtab/zsh/__tabtab.zsh || true";

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";

      plugins = [
        "git"
        "history"
        "npm"
        "docker"
      ];
      extraConfig = ''
        DISABLE_AUTO_TITLE=true
      '';
    };
  };

  # Ssh
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
      "VPN" = {
        host = "vpn";
        hostname = "91.214.190.25";
        port = 22;
        user = "debian";
        identityFile = "~/.ssh/id_rsa_infomaniak";
        remoteForwards = [
          {
            bind.port = 9933;
            host.address = "localhost";
            host.port = 22;
          }
          {
            bind.port = 9999;
            host.address = "localhost";
            host.port = 3000;
          }
        ];
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

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    attachExistingSession = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
