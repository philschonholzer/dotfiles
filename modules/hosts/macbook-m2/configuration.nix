{ inputs, ... }:
let
  inherit (inputs) self home-manager;
in
{
  flake.homeConfigurations.macbook-m2 = home-manager.lib.homeManagerConfiguration {
    pkgs = self.lib.pkgsFor."aarch64-linux";
    modules = [
      self.modules.homeManager.philip
      self.modules.homeManager.macbook-m2
      self.modules.homeManager.aarch64
      self.modules.homeManager.keyd
      self.modules.homeManager.genericLinux
    ];
  };

  flake.modules.homeManager.macbook-m2 = { pkgs, ... }: {
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

}
