{ ... }: {
  flake.modules.homeManager.philip = {
    programs.ripgrep.enable = true;
  };
}
