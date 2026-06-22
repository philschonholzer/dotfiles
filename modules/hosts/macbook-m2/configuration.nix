{ inputs, ... }:
let
  inherit (inputs)
    self
    nixpkgs
    home-manager
    ;

  supportedSystems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  pkgsFor = nixpkgs.lib.genAttrs supportedSystems (
    system:
    import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-39.8.10" ];
      };
      overlays = builtins.attrValues inputs.self.overlays;
    }
  );

in
{
  flake.modules.homeManager.macbook-m2 =
    {
      pkgs,
      ...
    }:
    {
      home.stateVersion = "25.11";

      targets.genericLinux = {
        enable = true;
        gpu.enable = false;
      };

      nix.package = pkgs.nix;
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };

      services.niri.configFile = ./niri.kdl;

      programs.home-manager.enable = true;
    };
  flake.homeConfigurations.macbook-m2 = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor."aarch64-linux";
    modules = [
      self.modules.homeManager.philip
      self.modules.homeManager.macbook-m2
      self.modules.homeManager.aarch64
      self.modules.homeManager.keyd
      self.modules.homeManager.genericLinux
    ];
  };
}
