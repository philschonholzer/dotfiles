{ ... }: {
  flake.modules.homeManager.apps = { pkgs, ... }: {
    home.packages = [ pkgs.nmgui ];
  };
}
