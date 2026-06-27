{ ... }: {
  flake.modules.homeManager.philip = { pkgs, ... }: {
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

    programs.zsh.shellAliases.oc = "opencode --port";
  };
}
