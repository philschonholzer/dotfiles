inputs: {...}: {
  imports = [
    (import ./waybar inputs)
    ./hypridle.nix
    ./hyprpaper.nix
    (import ./theme.nix inputs)
  ];
}
