{ ... }: {
  flake.modules.homeManager.philip = {
    programs.joplin-desktop.enable = true;
  };
}
