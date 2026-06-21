{ ... }: {
  flake.modules.homeManager.common-nixos = { pkgs, ... }: {

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
