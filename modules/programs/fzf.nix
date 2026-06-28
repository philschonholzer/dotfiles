{ ... }: {
  flake.modules.homeManager.base = { ... }: {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
