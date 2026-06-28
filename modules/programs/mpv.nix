{ ... }: {
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = with pkgs; [ mpv ];

    xdg.configFile."mpv/mpv.conf".text = ''
      gpu-context=wayland
    '';
  };
}
