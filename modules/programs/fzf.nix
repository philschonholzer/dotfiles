{ ... }: {
  flake.modules.homeManager.cli = { ... }: {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
