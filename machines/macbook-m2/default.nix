{
  pkgs,
  dictation-pkg,
  ...
}:
{
  imports = [
    ../../home-manager/arm.nix
  ];

  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = [
    # Nerd-dictation - offline speech-to-text
    dictation-pkg.dictation # Helper script: dictation en/de/stop/status
    dictation-pkg.nerd-dictation # Main command
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

  services.niri = {
    enable = true;
    configFile = ./niri.kdl;
    defaultColumnWidth = "fixed 1280";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
