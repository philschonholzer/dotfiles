{
  home-manager,
  nix-colors,
  ...
}: {
  imports = [
    ../configuration.nix
    ../modules
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
            ../home-manager/x86.nix
          ];
        };
      };
    }
  ];
}
