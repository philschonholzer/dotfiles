{ ... }: {
  flake.modules.homeManager.apps = {
    programs.joplin-desktop.enable = true;
  };
}
