{nix-colors}: {...}: {
  imports = [
    (import ./waybar {inherit nix-colors;})
    ./swayidle.nix
    ./hyprpaper.nix
    (import ./theme.nix {inherit nix-colors;})
  ];
}
