{ ... }: {
  flake.modules.homeManager.nixos = { pkgs, ... }: {

    home.packages = with pkgs; [
      unstable.blender
      kdePackages.kdenlive
      ffmpeg-full
      xwayland-satellite
      libreoffice
      alacritty
      python3
    ];
  };
}
