{
  flake.modules.homeManager.base =
    { lib, pkgs, ... }:
    let
      mattPocockSkills = pkgs.fetchFromGitHub {
        owner = "mattpocock";
        repo = "skills";
        rev = "5863806dd4e15c63174bee4e7515a4256792ecfa";
        hash = "sha256-AYSRCvBL8TDDdW3rgKu2T7gl4YYDoDId0jYbabEFyfs=";
      };
    in
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
              "git push" = "deny";
              "git push *" = "deny";
              "git -c * push*" = "deny";
              "git --git-dir* push*" = "deny";
            };
          };
          "mcp" = {
            "servers" = {
              "nixos" = {
                "type" = "local";
                "command" = [ (lib.getExe pkgs.unstable.mcp-nixos) ];
              };
              "trello" = {
                "type" = "remote";
                "url" = "https://mcp.trello.com/v1";
              };
            };
          };
          "plugin" = [
            "opencode-models-discovery"
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
              "model" = "github-copilot/claude-opus-5.5";
            };
            "build" = {
              "model" = "github-copilot/gpt-6.1-sol";
            };
          };
        };
        agents = {
          copy-writer = ./agent/copy-writer.md;
          assistent = ./agent/assistent.md;
        };
        skills = {
          unslop = ./skill/unslop/SKILL.md;
          # grill-with-docs delegates to these skills; keep their supporting files too.
          grill-with-docs = "${mattPocockSkills}/skills/engineering/grill-with-docs";
          grilling = "${mattPocockSkills}/skills/productivity/grilling";
          domain-modeling = "${mattPocockSkills}/skills/engineering/domain-modeling";
        };
      };

      xdg.desktopEntries.opencode = lib.mkIf pkgs.stdenv.isLinux {
        name = "OpenCode";
        genericName = "AI Coding Agent";
        comment = "Open OpenCode in Foot terminal";
        exec = "footclient --app-id=dev.opencode --title=OpenCode opencode";
        icon = ./icons/opencode-dark.svg;
        terminal = false;
        type = "Application";
        settings.StartupWMClass = "dev.opencode";
        categories = [
          "Development"
          "Utility"
        ];
      };

      programs.zsh.shellAliases.oc = "opencode";
    };
}
