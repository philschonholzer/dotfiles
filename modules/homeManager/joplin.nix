{ ... }: {
  flake.modules.homeManager.joplin = {
    programs.joplin-desktop.enable = true;
  };
}
