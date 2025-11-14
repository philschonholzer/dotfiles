{
  imports = [./common.nix];

  # arm-specific: packages that are disabled on ARM (commented out on x86)
  # If you want to enable any of these later, add them to home.packages

  # Niri configuration for ARM (MacBook)
  # Note: configFile is specified per-machine in machines/<machine>/default.nix
  services.niri = {
    enable = true;
    enableSwayidle = true;
  };
}
