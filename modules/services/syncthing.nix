{ ... }: {
  flake.modules.homeManager.base = {
    services.syncthing = {
      enable = true;
      overrideDevices = false;
      overrideFolders = false;

      settings.folders.private-scripts = {
        id = "private-scripts";
        label = "Private scripts";
        path = "/home/philip/Projects/private/scripts";
      };
    };
  };
}
