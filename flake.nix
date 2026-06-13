{
  description = "My Beelink setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia.url = "github:noctalia-dev/noctalia";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    wlavu = {
      url = "github:philschonholzer/wlavu";
      inputs.nixpkgs.follows = "nixpkgs"; # Use your nixpkgs, not wlavu's
    };
    dictation = {
      url = "github:philschonholzer/dictation";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sqlit = {
      url = "github:Maxteabag/sqlit";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    niri-autoselect-portal = {
      url = "git+https://codeberg.org/debugloop/niri-autoselect-portal.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-colors,
      noctalia,
      noctalia-greeter,
      wlavu,
      dictation,
      sqlit,
      niri-autoselect-portal,
      ...
    }:
    let
      inherit (self) outputs;
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "electron-39.8.10"
            ];
          };
          overlays = builtins.attrValues (
            import ./overlays.nix {
              inputs = {
                inherit nixpkgs-unstable;
              };
            }
          );
        }
      );
    in
    {
      overlays = import ./overlays.nix {
        inputs = {
          inherit nixpkgs-unstable;
        };
      };
      # Used with `nixos-rebuild --flake .#<hostname>`
      nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            outputs
            nix-colors
            home-manager
            dictation
            niri-autoselect-portal
            noctalia-greeter
            ;
          wlavu = wlavu.packages."x86_64-linux".default;
          sqlit-pkg = sqlit.packages."x86_64-linux".default;
          inherit noctalia;
        };
        modules = [
          ./machines/beelink
          { networking.hostName = "beelink"; }
        ];
      };
      nixosConfigurations.macbook-intel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            outputs
            nix-colors
            home-manager
            dictation
            niri-autoselect-portal
            noctalia-greeter
            ;
          wlavu = wlavu.packages."x86_64-linux".default;
          sqlit-pkg = sqlit.packages."x86_64-linux".default;
          inherit noctalia;
        };
        modules = [
          ./machines/macbook-intel
          { networking.hostName = "macbook-intel"; }
        ];
      };
      homeConfigurations.macbook-m2 = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor."aarch64-linux";
        extraSpecialArgs = {
          inherit
            outputs
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
          ./machines/macbook-m2
        ];
      };
      homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor."aarch64-darwin";
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./machines/darwin.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      formatter = {

        # Formatter for `nix fmt`
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
        aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
        aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
      };
    };
}
