{
  home-manager,
  nix-colors,
  vicinae,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../configuration.nix
    ../../modules
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit nix-colors;};
        users.philip = {
          imports = [
            nix-colors.homeManagerModules.default
            vicinae.homeManagerModules.default
            ../../home-manager/x86.nix
          ];
        };
      };
    }
  ];
}
