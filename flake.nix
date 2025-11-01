{
  description = "My Beelink setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-colors,
    ...
  }: let
    inherit (self) outputs;
    pkgs = import nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
  in {
    overlays = import ./overlays.nix {
      inputs = {
        inherit nixpkgs-unstable;
      };
    };
    # Used with `nixos-rebuild --flake .#<hostname>`
    nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit outputs nix-colors home-manager;};
      modules = [./machines/beelink];
    };
    nixosConfigurations.macbook-intel = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit outputs nix-colors home-manager;};
      modules = [./machines/macbook-intel];
    };
    nixosConfigurations.macbook = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit outputs nix-colors home-manager;};
      modules = [./machines/macbook];
    };
    homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./machines/darwin.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}
