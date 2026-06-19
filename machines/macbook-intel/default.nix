{
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules/keyd.nix
  ];

  # Machine-specific home-manager configuration
  home-manager.users.philip = {
    services.niri = {
      configFile = ./niri.kdl;
    };
  };
}
