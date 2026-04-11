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
      "provider" = {
        "lmstudio" = {
          "npm" = "@ai-sdk/openai-compatible";
          "name" = "LM Studio (local)";
          "options" = {
            "baseURL" = "http://192.168.1.65:1234/v1";
          };
          "models" = {
            "google/gemma-4-31b" = {
              "name" = "Gemma 4 31b";
            };
            "google/gemma-4-e4b" = {
              "name" = "Gemma 4 e4b";
            };
            "google/gemma-4-26b-a4b" = {
              "name" = "Gemma 26b A4B";
            };
          };
        };
      };
    };
  };

  programs.zsh.shellAliases.oc = "opencode --port";
}
