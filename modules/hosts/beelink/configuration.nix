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
          self.modules.homeManager.amd
          self.modules.homeManager.beelink
        ];
      }
    ];
  };

  flake.modules.homeManager.beelink = { pkgs, ... }: {
    programs.umbriel.settings = {
      input.mouse = {
        natural_scroll = true;
        left_handed = true;
      };
    };
  };

  flake.modules.nixos.beelink = {
    networking.hostName = "beelink";

    home-manager.users.philip = {
      home.stateVersion = "25.05";

      programs.foot.settings.main.font = "JetBrainsMono Nerd Font Mono:size=12";

      services.niri = {
        configFile = ./niri.kdl;
      };
    };
  };
}
