inputs: {...}: {
  imports = [
    ./bindings.nix
    ./hyprland.nix
    (import ./waybar.nix inputs)
    ./windows.nix
  ];
}
