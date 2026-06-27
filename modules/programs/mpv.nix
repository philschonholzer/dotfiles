{ ... }: {
  flake.modules.homeManager.philip = { pkgs, ... }: {
    home.packages = with pkgs; [ mpv ];

    xdg.configFile."mpv/mpv.conf".text = ''
      gpu-context=wayland
    '';
  };
}
