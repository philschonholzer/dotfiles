{ inputs, ... }:
let
  inherit (inputs)
    self
    nixpkgs
    nixpkgs-unstable
    home-manager
    nix-colors
    noctalia
    noctalia-greeter
    wlavu
    dictation
    sqlit
    niri-autoselect-portal
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
        import ../overlays.nix {
          inputs = { inherit nixpkgs-unstable; };
        }
      );
    }
  );
in
{
  flake.overlays = import ../overlays.nix {
    inputs = { inherit nixpkgs-unstable; };
  };

  flake.nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      outputs = self;
      inherit
        nix-colors
        home-manager
        noctalia
        niri-autoselect-portal
        noctalia-greeter
        ;
      wlavu = wlavu.packages."x86_64-linux".default;
      sqlit-pkg = sqlit.packages."x86_64-linux".default;
      dictation = dictation;
    };
    modules = [
      self.modules.nixos.core
      self.modules.nixos.desktop
      self.modules.nixos.hardware
      self.modules.nixos.network
      self.modules.nixos.security
      self.modules.nixos.apps
      ../machines/beelink
      { networking.hostName = "beelink"; }
    ];
  };

  flake.nixosConfigurations.macbook-intel = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      outputs = self;
      inherit
        nix-colors
        home-manager
        noctalia
        niri-autoselect-portal
        noctalia-greeter
        ;
      wlavu = wlavu.packages."x86_64-linux".default;
      sqlit-pkg = sqlit.packages."x86_64-linux".default;
      dictation = dictation;
    };
    modules = [
      self.modules.nixos.core
      self.modules.nixos.desktop
      self.modules.nixos.hardware
      self.modules.nixos.network
      self.modules.nixos.security
      self.modules.nixos.apps
      ../machines/macbook-intel
      { networking.hostName = "macbook-intel"; }
    ];
  };

  flake.homeConfigurations.macbook-m2 = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor."aarch64-linux";
    extraSpecialArgs = {
      outputs = self;
      inherit
        nix-colors
        home-manager
        noctalia
        ;
      wlavu = wlavu.packages."aarch64-linux".default;
      dictation-pkg = dictation.packages."aarch64-linux";
      sqlit-pkg = sqlit.packages."aarch64-linux".default;
    };
    modules = [
      nix-colors.homeManagerModules.default
      noctalia.homeModules.default
      ../machines/macbook-m2
    ];
  };

  flake.homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor."aarch64-darwin";
    modules = [ ../machines/darwin.nix ];
  };
}
