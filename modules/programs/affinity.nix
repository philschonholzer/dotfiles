{ ... }: {
  flake.modules.homeManager.apps = { pkgs, ... }:
  let
    affinityLauncher = pkgs.writeShellScriptBin "affinity-launcher" ''
      exec nix run github:mrshmllow/affinity-nix#v3
    '';
  in
  {
    home.packages = [ affinityLauncher ];
    xdg.desktopEntries = {
      affinity = {
        name = "Affinity";
        comment = "Affinity Photo/Designer/Publisher";
        exec = "affinity-launcher";
        icon = ../theme/affinity.svg;
        categories = [
          "Graphics"
          "Photography"
          "Publishing"
        ];
        type = "Application";
        terminal = false;
      };
    };
  };
}
