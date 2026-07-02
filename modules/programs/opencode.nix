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
        "plugin" = [
          "opencode-models-discovery"
          "vimcode@git+https://github.com/oribarilan/vimcode.git#v0.15.1"
        ];
        "provider" = {
          "ollama" = {
            "npm" = "@ai-sdk/openai-compatible";
            "name" = "Ollama (MacMini)";
            "options" = {
              "baseURL" = "http://192.168.1.65:11434/v1";
              "modelsDiscovery" = {
                "enabled" = true;
              };
            };
          };
        };
      };
    };

    xdg.desktopEntries.opencode = {
      name = "OpenCode";
      genericName = "AI Coding Agent";
      comment = "Open OpenCode in Ghostty terminal";
      exec = "ghostty -e opencode";
      icon = ./icons/opencode-dark.svg;
      terminal = false;
      type = "Application";
      categories = [
        "Development"
        "Utility"
      ];
    };

    programs.zsh.shellAliases.oc = "opencode --port";
  };
}
