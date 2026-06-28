{ inputs, ... }:
let
  inherit (inputs) self nixpkgs;
in
{
  flake.nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.beelink
      self.modules.nixos.base
      {
        home-manager.users.philip.imports = [
          self.modules.homeManager.base
          self.modules.homeManager.nixos
          self.modules.homeManager.x86_64
        ];
      }
    ];
  };

  flake.modules.nixos.beelink = {
    networking.hostName = "beelink";

    home-manager.users.philip = {
      home.stateVersion = "25.05";

      services.niri = {
        configFile = ./niri.kdl;
      };
    };
  };
}
