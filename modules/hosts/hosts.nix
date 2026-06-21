{ inputs, ... }:
let
  inherit (inputs)
    self
    nixpkgs
    nixpkgs-unstable
    home-manager
    nix-colors
    noctalia
    wlavu
    dictation
    sqlit
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
      overlays = builtins.attrValues (
        import ../../overlays.nix {
          inputs = { inherit nixpkgs-unstable; };
        }
      );
    }
  );

  # Home-manager modules shared across all configurations
  hmModules = [
    self.modules.homeManager.philip
    nix-colors.homeManagerModules.default
    noctalia.homeModules.default
  ];

  # Wraps HM modules into a NixOS module via home-manager.users.philip.imports
  hmModuleForNixos = { pkgs, ... }: {
    home-manager.users.philip.imports = hmModules ++ [
      self.modules.homeManager.nixos
      self.modules.homeManager.x86_64
    ];
  };
in
{
  flake = {
    overlays = import ../../overlays.nix {
      inputs = { inherit nixpkgs-unstable; };
    };

    nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.beelink
        self.modules.nixos.base
        hmModuleForNixos
        { networking.hostName = "beelink"; }
      ];
    };

    nixosConfigurations.macbook-intel = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.modules.nixos.macbook-intel
        self.modules.nixos.base
        self.modules.nixos.keyd
        hmModuleForNixos
        { networking.hostName = "macbook-intel"; }
      ];
    };

    homeConfigurations.macbook-m2 = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor."aarch64-linux";
      extraSpecialArgs = {
        inherit
          nix-colors
          noctalia
          ;
        wlavu = wlavu.packages."aarch64-linux".default;
        sqlit-pkg = sqlit.packages."aarch64-linux".default;
      };
      modules = hmModules ++ [
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
