{ ... }: {
  flake.modules.homeManager.aarch64 = { pkgs, ... }: {
    home.packages = with pkgs; [
      slacky
    ];
  };
}
