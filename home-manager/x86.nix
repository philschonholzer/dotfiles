{pkgs, ...}: {
  imports = [./common-nixos.nix];

  # x86-specific packages
  home.packages = with pkgs; [
    unstable.morgen
    slack
    freelens-bin
    unstable.onlyoffice-desktopeditors
    kchat
    brightnessctl
  ];

  # Niri configuration for x86
  # Note: configFile is specified per-machine in machines/<machine>/default.nix
  services.niri = {
    enable = true;
    enableSwayidle = true;
  };
}
