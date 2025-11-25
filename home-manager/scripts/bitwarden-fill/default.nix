{pkgs, ...}: let
  bitwarden-fill = pkgs.writeShellApplication {
    name = "bitwarden-fill";
    runtimeInputs = with pkgs; [
      rbw
      gnugrep
      gawk
      gnused
      coreutils
      fuzzel
    ];
    text = builtins.readFile ./bitwarden-fill.sh;
  };
in {
  home.packages = [bitwarden-fill];
}
