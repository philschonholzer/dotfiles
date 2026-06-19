{ ... }: {
  flake.modules.homeManager.nmgui = { pkgs, ... }: {
    home.packages = [ pkgs.nmgui ];
  };
}
