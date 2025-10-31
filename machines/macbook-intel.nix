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
        users.philip = {
          imports = [
            nix-colors.homeManagerModules.default
            (import ../home-manager/x86.nix {inherit nix-colors;})
          ];
        };
      };
    }
  ];
}
