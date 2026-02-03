{
  description = "My Beelink setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-colors,
      vicinae,
      wlavu,
      dictation,
      sqlit,
      ...
    }:
    let
      inherit (self) outputs;
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
        overlays = builtins.attrValues (
          import ./overlays.nix {
            inputs = {
              inherit nixpkgs-unstable;
            };
          }
        );
      };
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
            vicinae
            dictation
            ;
          wlavu = wlavu.packages."x86_64-linux".default;
          sqlit-pkg = sqlit.packages."x86_64-linux".default;
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
            vicinae
            dictation
            ;
          wlavu = wlavu.packages."x86_64-linux".default;
          sqlit-pkg = sqlit.packages."x86_64-linux".default;
        };
        modules = [
          ./machines/macbook-intel
          { networking.hostName = "macbook-intel"; }
        ];
      };
      nixosConfigurations.macbook-m2 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit
            outputs
            nix-colors
            home-manager
            vicinae
            dictation
            ;
          wlavu = wlavu.packages."aarch64-linux".default;
          sqlit-pkg = sqlit.packages."aarch64-linux".default;
        };
        modules = [
          ./machines/macbook-m2
          { networking.hostName = "macbook-m2"; }
        ];
      };
      homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./machines/darwin.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };

      # Formatter for `nix fmt`
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    };
}
