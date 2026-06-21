{ inputs, ... }:
let
  inherit (inputs)
    self
    nixpkgs
    home-manager
    ;

  supportedSystems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  pkgsFor = nixpkgs.lib.genAttrs supportedSystems (
    system:
    import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-39.8.10" ];
      };
      overlays = builtins.attrValues inputs.self.overlays;
    }
  );

in
{
  flake = {
    nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.beelink
        self.modules.nixos.base
        {
          home-manager.users.philip.imports = [
            self.modules.homeManager.philip
            self.modules.homeManager.nixos
            self.modules.homeManager.x86_64
          ];
        }
      ];
    };

    nixosConfigurations.macbook-intel = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.macbook-intel
        self.modules.nixos.base
        self.modules.nixos.keyd
        {
          home-manager.users.philip.imports = [
            self.modules.homeManager.philip
            self.modules.homeManager.nixos
            self.modules.homeManager.x86_64
          ];
        }
      ];
    };

    homeConfigurations.macbook-m2 = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor."aarch64-linux";
      modules = [
        self.modules.homeManager.philip
        self.modules.homeManager.macbook-m2
        self.modules.homeManager.aarch64
        self.modules.homeManager.keyd
        self.modules.homeManager.genericLinux
      ];
    };

    homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor."aarch64-darwin";
      modules = [
        self.modules.homeManager.darwin
      ];
    };
  };
}
