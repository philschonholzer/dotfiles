{ ... }: {
  flake.modules.homeManager.cli = {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
    };
  };
}
