{ ... }: {
  flake.modules.homeManager.base = {
    programs.lazydocker.enable = true;
  };
}
