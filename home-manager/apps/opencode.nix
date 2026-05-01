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
      ];
      "provider" = {
        "lmstudio" = {
          "npm" = "@ai-sdk/openai-compatible";
          "name" = "LM Studio (local)";
          "options" = {
            "baseURL" = "http://192.168.1.65:1234/v1";
          };
        };
      };
    };
  };

  programs.zsh.shellAliases.oc = "opencode --port";
}
