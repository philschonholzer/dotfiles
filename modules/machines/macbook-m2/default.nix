{ inputs, ... }: {
  flake.modules.homeManager.macbook-m2 = { pkgs, dictation-pkg, ... }: {
    home.stateVersion = "25.11";

    home.packages = [
      dictation-pkg.dictation
      dictation-pkg.nerd-dictation
    ];

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
