{ ... }: {
  flake.modules.homeManager.genericLinux = { pkgs, ... }: {
    home.packages = [ pkgs.ente-auth ];
  };

  flake.modules.homeManager.nixos = { pkgs, ... }: {
    home.packages = [ pkgs.ente-auth ];
  };

  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.ente-auth ];
  };
}
