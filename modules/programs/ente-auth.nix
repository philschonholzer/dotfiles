{ inputs, ... }: {
  flake.modules.homeManager.genericLinux =
    { pkgs, lib, ... }:
    let
      inherit (inputs.self.lib.nixgl { inherit pkgs lib; }) wrapGL;
    in
    {
      home.packages = [ (wrapGL pkgs.ente-auth "enteauth") ];
    };

  flake.modules.homeManager.nixos = { pkgs, ... }: {
    home.packages = [ pkgs.ente-auth ];
  };

  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.ente-auth ];
  };
}
