{ inputs, ... }: {
  flake.modules.nixos.base = {
    programs.localsend.enable = true;
  };

  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.localsend ];
  };

  flake.modules.homeManager.genericLinux =
    { pkgs, lib, ... }:
    let
      inherit (inputs.self.lib.nixgl { inherit pkgs lib; }) wrapGL;
    in
    {
      home.packages = [ (wrapGL pkgs.localsend "localsend_app") ];
    };
}
