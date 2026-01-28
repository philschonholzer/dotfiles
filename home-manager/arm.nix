{nix-colors,...}: {
  imports = [./common.nix];

  colorScheme = nix-colors.colorSchemes.kanagawa;
  # arm-specific: packages that are disabled on ARM (commented out on x86)
  # If you want to enable any of these later, add them to home.packages
}
