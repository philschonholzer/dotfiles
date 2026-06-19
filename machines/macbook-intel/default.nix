{
  imports = [
    ./hardware-configuration.nix
  ];

  # Machine-specific home-manager configuration
  home-manager.users.philip = {
    services.niri = {
      configFile = ./niri.kdl;
    };
  };
}
