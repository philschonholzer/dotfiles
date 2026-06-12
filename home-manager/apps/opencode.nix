{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    settings = {
      "permission" = {
        "bash" = {
          "*" = "allow";
          "nixos-rebuild *" = "deny";
          "nixos-rebuild *--dry-build*" = "allow";
          "git push*" = "deny";
        };
      };
      "plugin" = [
        "opencode-lmstudio@latest"
        "opencode-models-discovery"
      ];
      "provider" = {
        "lmstudio" = {
          "npm" = "@ai-sdk/openai-compatible";
          "name" = "LM Studio (MacMini)";
          "options" = {
            "baseURL" = "http://192.168.1.65:1234/v1";
          };
        };
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
}
