{pkgs, ...}: {
  imports = [
    ./common-base.nix
    ./desktop-manager
    ./apps/dictation.nix
    ./apps/kdrive.nix
    ./apps/table-plus.nix
  ];

  # Enable Ghostty terminal (NixOS only)
  programs.ghostty.enable = true;

  # NixOS systems use an older state version
  home.stateVersion = "25.05";

  # NixOS-specific packages (heavy desktop apps)
  home.packages = with pkgs; [
    unstable.blender
    ente-auth
    kdePackages.kdenlive
    ffmpeg-full
    xwayland-satellite
    libreoffice
    alacritty
  ];
}
