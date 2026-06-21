{ ... }: {
  flake.modules.homeManager.philip = {
    programs.lazydocker.enable = true;
  };
}
