{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.wlvncc
  ];
  xdg.desktopEntries = {
    wlvncc = {
      name = "VNC";
      comment = "Remote Desktop to MacMini";
      # Add a script in ~/.secrets/vnc-mac-mini-auth.sh
      #
      ##!/usr/bin/env bash
      #
      # echo -e "user\npassword"
      exec = "wlvncc -A ${config.home.homeDirectory}/.secrets/vnc-mac-mini-auth.sh 192.168.1.65";
    };
  };
}
