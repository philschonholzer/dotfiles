{ ... }: {
  flake.modules.nixos.base = {
    programs.localsend.enable = true;
  };

  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.localsend ];
  };

  flake.modules.homeManager.genericLinux = { pkgs, ... }: {
    home.packages = [ pkgs.localsend ];
  };
}
