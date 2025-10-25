inputs: {...}: {
  imports = [
    (import ./waybar.nix inputs)
    ./hypridle.nix
    ./hyprpaper.nix
    (import ./theme.nix inputs)
  ];
}
