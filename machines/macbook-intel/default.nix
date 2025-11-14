{home-manager, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../../modules/keyd.nix
  ];

  # Machine-specific home-manager configuration
  home-manager.users.philip = {
    services.niri = {
      configFile = "niri-macbook-intel.kdl";
      defaultColumnWidth = "fixed 1280";
    };
  };
}
