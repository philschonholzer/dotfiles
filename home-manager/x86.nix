{pkgs, ...}: {
  imports = [./common-nixos.nix];

  # x86-specific packages
  home.packages = with pkgs; [
    morgen  # Version 3.6.19 - unstable 4.0.4 has GPU access issues
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
