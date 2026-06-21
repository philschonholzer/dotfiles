{ ... }: {
  flake.modules.homeManager.philip = {
    programs.fd.enable = true;
  };
}
