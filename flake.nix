{
  description = "My Beelink setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    omarchy-nix = {
      url = "github:henrysipp/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    omarchy-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays.nix {inherit inputs;};
    # Used with `nixos-rebuild --flake .#<hostname>`
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit outputs;};
      modules = [
        ./configuration.nix
        omarchy-nix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          omarchy = {
            full_name = "Philip Schönholzer";
            email_address = "philip.schoenholzer@apptiva.ch";
            theme = "nord";
            monitors = ["DP-3, 5120x2160, 0x0, 1.6"];
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.philip = {
              imports = [
                (import ./machines/beelink.nix inputs)
                omarchy-nix.homeManagerModules.default
              ];
            };
          };
        }
      ];
    };
    homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
      system = "aarch64-darwin";
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./machines/darwin.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
