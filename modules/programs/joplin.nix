{ ... }: {
  flake.modules.homeManager.base = {
    programs.joplin-desktop.enable = true;
  };
}
