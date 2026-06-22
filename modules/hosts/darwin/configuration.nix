{ inputs, ... }:
let
  inherit (inputs)
    self
    nixpkgs
    home-manager
    ;

  supportedSystems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  pkgsFor = nixpkgs.lib.genAttrs supportedSystems (
    system:
    import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-39.8.10" ];
      };
      overlays = builtins.attrValues inputs.self.overlays;
    }
  );

in
{
  flake.homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor."aarch64-darwin";
    modules = [
      self.modules.homeManager.darwin
    ];
  };
  flake.modules.homeManager.darwin = { pkgs, ... }: {
    imports = [ ];
    home.username = "philip";
    home.homeDirectory = "/Users/philip";

    home.stateVersion = "23.11";

    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [
        "JetBrainsMono Nerd Font"
      ];
    };
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
      nixfmt
      lazydocker
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      nerd-fonts.jetbrains-mono
      glow
      superfile
      typst
      typstyle
      mosh
    ];

    home.file = {
      ".config/ghostty/config".text = ''
        font-family = JetBrainsMono Nerd Font Mono
        font-size = 16
        theme = Kanagawa Wave
      '';
    };

    home.sessionVariables = {
      PROMPT = "$ ";
    };

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
            on = [ "<C-p>" ];
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

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

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

    programs.ssh = {
      enable = true;
      includes = [ "~/.colima/ssh_config" ];

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

    programs.home-manager.enable = true;
  };
}
