{ ... }: {
  flake.modules.homeManager.base = { pkgs, ... }: {
    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
      settings = {
        "permission" = {
          "bash" = {
            "*" = "allow";
            "nixos-rebuild *" = "deny";
            "nixos-rebuild *--dry-build*" = "allow";
            "git push" = "deny";
            "git push *" = "deny";
            "git -c * push*" = "deny";
            "git --git-dir* push*" = "deny";
          };
        };
        "mcp" = {
          "trello" = {
            "type" = "remote";
            "url" = "https://mcp.trello.com/v1";
            "enabled" = true;
          };
        };
        "plugin" = [
          "opencode-models-discovery"
          "vimcode@git+https://github.com/oribarilan/vimcode.git#v0.15.1"
        ];
        "provider" = {
          "ollama" = {
            "npm" = "@ai-sdk/openai-compatible";
            "name" = "Ollama (MacMini)";
            "options" = {
              "baseURL" = "http://philips-mac-mini:11434/v1";
              "modelsDiscovery" = {
                "enabled" = true;
              };
            };
          };
          "lm-studio" = {
            "npm" = "@ai-sdk/openai-compatible";
            "name" = "LM Studio (MacMini)";
            "options" = {
              "baseURL" = "http://philips-mac-mini:1234/v1";
              "modelsDiscovery" = {
                "enabled" = true;
              };
            };
          };
        };
        "agent" = {
          "plan" = {
            "model" = "github-copilot/gpt-5.6-sol";
          };
          "build" = {
            "model" = "github-copilot/gpt-5.6-luna";
          };
        };
      };
      agents = {
        copy-writer = ./agent/copy-writer.md;
        assistent = ./agent/assistent.md;
      };
      skills = {
        unslop = ./skill/unslop/SKILL.md;
      };
    };

    xdg.desktopEntries.opencode = {
      name = "OpenCode";
      genericName = "AI Coding Agent";
      comment = "Open OpenCode in Ghostty terminal";
      exec = "ghostty --class=dev.opencode --title=OpenCode -e opencode --agent assistent";
      icon = ./icons/opencode-dark.svg;
      terminal = false;
      type = "Application";
      settings.StartupWMClass = "dev.opencode";
      categories = [
        "Development"
        "Utility"
      ];
    };

    programs.zsh.shellAliases.oc = "opencode --port";
  };
}
