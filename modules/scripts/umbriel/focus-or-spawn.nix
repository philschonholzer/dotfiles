{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "umbriel-focus-or-spawn";
          runtimeInputs = [ pkgs.jq ];
          text = builtins.readFile ./focus-or-spawn.sh;
        })
      ];
    };
}
