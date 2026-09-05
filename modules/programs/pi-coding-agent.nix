{ ... }:
{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # programs.pi-coding-agent = {
      #   enable = true;
      #   package = pkgs.unstable.pi-coding-agent;
      #
      #   settings = {
      #     # Pi packages providing the configured extensions and skills.
      #     packages = [
      #       "npm:pi-lmstudio"
      #       "git:https://github.com/k0valik/pi-answr"
      #       "npm:@vtstech/pi-ollama-sync"
      #       "npm:pi-mcp-adapter"
      #     ];
      #     defaultProvider = "github-copilot";
      #     defaultModel = "gpt-5.6-sol";
      #     defaultThinkingLevel = "low";
      #     theme = "dark";
      #     hideThinkingBlock = false;
      #   };
      # };
    };
}
