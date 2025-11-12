{config, ...}: {
  imports = [./common.nix];

  # arm-specific: packages that are disabled on ARM (commented out on x86)
  # If you want to enable any of these later, add them to home.packages

  # Niri configuration for ARM (MacBook)
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/desktop-manager/niri-m.kdl";
}
