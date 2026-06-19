{ ... }: {
  flake.modules.homeManager.niri-window-indicator = { pkgs, ... }:
  let
    windowIndicator = pkgs.writeShellScriptBin "niri-window-indicator" (
      builtins.readFile ./window-indicator.sh
    );
  in
  {
    home.packages = [ windowIndicator ];
  };
}
