{ ... }: {
  flake.modules.homeManager.common-nixos = { pkgs, ... }: {
    programs.ghostty.enable = true;

    home.stateVersion = "25.05";

    home.packages = with pkgs; [
      unstable.blender
      ente-auth
      kdePackages.kdenlive
      ffmpeg-full
      xwayland-satellite
      libreoffice
      alacritty
      python3
    ];
  };
}
