{
  pkgs,
  lib,
  ...
}:
let
  open-downloads = pkgs.writeShellApplication {
    name = "open-downloads";
    runtimeInputs = with pkgs; [
      fd
      fuzzel
      xdg-utils
      libnotify
      coreutils
      wl-clipboard
    ];
    text = builtins.readFile ./open-downloads.sh;
  };
in
{
  home.packages = [ open-downloads ];
}
