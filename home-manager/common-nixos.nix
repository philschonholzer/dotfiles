{pkgs, ...}: {
  imports = [
    ./common-base.nix
    ./desktop-manager
    ./apps/dictation.nix
  ];

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
