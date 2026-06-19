{ ... }: {
  flake.modules.homeManager.cli = {
    programs.lazydocker.enable = true;
  };
}
