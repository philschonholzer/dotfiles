inputs: [
  ../configuration.nix
  ../modules
  inputs.home-manager.nixosModules.home-manager
  {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      users.philip = {
        imports = [
          inputs.nix-colors.homeManagerModules.default
          (import ../home-manager/x86.nix inputs)
        ];
      };
    };
  }
]
