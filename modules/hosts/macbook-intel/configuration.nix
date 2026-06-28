{ inputs, ... }:
let
  inherit (inputs) self nixpkgs;
in
{
  flake.nixosConfigurations.macbook-intel = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.macbook-intel
      self.modules.nixos.base
      self.modules.nixos.keyd
      {
        home-manager.users.philip.imports = [
          self.modules.homeManager.base
          self.modules.homeManager.nixos
          self.modules.homeManager.x86_64
        ];
      }
    ];
  };

  flake.modules.nixos.macbook-intel = {
    networking.hostName = "macbook-intel";

    home-manager.users.philip = {
      home.stateVersion = "25.05";

      services.niri = {
        configFile = ./niri.kdl;
      };
    };
  };
}
