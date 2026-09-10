{ ... }:
{
  flake.modules.homeManager.darwin =
    { ... }:
    {
      programs.ghostty = {
        enable = true;
        settings = {
          font-family = "JetBrainsMono Nerd Font Mono";
          font-size = 16;
          theme = "Kanagawa Wave";
        };
      };
    };
}
