{ ... }: {
  flake.modules.homeManager.philip = { pkgs, ... }: {
    home.packages = [ pkgs.nmgui ];
  };
}
