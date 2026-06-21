{ ... }: {
  flake.modules.homeManager.philip = { pkgs, config, ... }: {
    home.packages = [
      pkgs.wlvncc
    ];
    xdg.desktopEntries = {
      wlvncc = {
        name = "VNC";
        comment = "Remote Desktop to MacMini";
        exec = "wlvncc -A ${config.home.homeDirectory}/.secrets/vnc-mac-mini-auth.sh 192.168.1.65";
      };
    };
  };
}
