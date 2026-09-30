{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "update-clients";
          runtimeInputs = with pkgs; [
            bash
            curl
            coreutils
            git
            jq
            nix
            nixfmt
            gnused
          ];
          text = builtins.readFile ./update-clients.sh;
        })
      ];
    };
}
