{ ... }: {
  flake.modules.homeManager.x86_64 = { pkgs, ... }: {
    home.packages = with pkgs; [
      morgen
      slack
      freelens-bin
      unstable.onlyoffice-desktopeditors
      kchat
    ];
  };
}
