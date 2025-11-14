{home-manager, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  # Machine-specific home-manager configuration
  home-manager.users.philip = {
    services.niri = {
      configFile = "niri-beelink.kdl";
    };
  };
}
