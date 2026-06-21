{ ... }: {
  flake.modules.homeManager.philip = {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
    };
  };
}
