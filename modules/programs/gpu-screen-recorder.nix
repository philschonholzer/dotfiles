{ ... }: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.gpu-screen-recorder.enable = true;
    };
  flake.modules.homeManager.nixos = { pkgs, ... }: {
    home.packages = [ pkgs.gpu-screen-recorder-gtk ];
  };
}
