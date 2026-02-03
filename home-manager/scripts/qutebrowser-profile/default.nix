{ pkgs, ... }:
let
  qutebrowserProfileIndicator = pkgs.writeShellScriptBin "qutebrowser-profile-indicator" (
    builtins.readFile ./qutebrowser-profile.sh
  );
in
{
  home.packages = [ qutebrowserProfileIndicator ];
}
