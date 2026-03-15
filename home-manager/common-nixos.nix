{pkgs, ...}: {
  imports = [
    ./common-base.nix
    ./desktop-manager
  ];

  # NixOS systems use an older state version
  home.stateVersion = "25.05";

  # NixOS-specific packages (heavy desktop apps)
  home.packages = with pkgs; [
    ente-auth
    kdePackages.kdenlive
    ffmpeg-full
    xwayland-satellite
    libreoffice
    alacritty
  ];
}
