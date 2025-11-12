{pkgs, ...}: let
  focusOrSpawns = pkgs.writeShellScriptBin "focus-or-spawn" (builtins.readFile ./focus-or-spawn.sh);
in {
  home.packages = [focusOrSpawns];
}
