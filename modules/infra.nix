{ inputs, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt;

    devShells.default = pkgs.mkShell {
      name = "nixos-config";
      packages = with pkgs; [
        nixfmt
        statix
        deadnix
        nix-output-monitor
      ];
    };
  };
}
