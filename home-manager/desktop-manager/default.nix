inputs: {...}: {
  imports = [
    (import ./waybar inputs)
    ./swayidle.nix
    ./hyprpaper.nix
    (import ./theme.nix inputs)
  ];
}
