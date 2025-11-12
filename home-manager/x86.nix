{
  pkgs,
  config,
  ...
}: {
  imports = [./common.nix];

  # x86-specific packages
  home.packages = with pkgs; [
    unstable.morgen
    slack
    lens
    onlyoffice-desktopeditors
    kchat
    brightnessctl
  ];

  # Niri configuration for x86
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/desktop-manager/niri.kdl";
}
