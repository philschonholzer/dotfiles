{ ... }: {
  flake.modules.homeManager.philip = { ... }: {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
