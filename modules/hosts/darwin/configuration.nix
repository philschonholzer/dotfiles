{ inputs, ... }:
let
  inherit (inputs) self home-manager;
in
{
  flake.homeConfigurations.darwin = home-manager.lib.homeManagerConfiguration {
    pkgs = self.lib.pkgsFor."aarch64-darwin";
    modules = [
      self.modules.homeManager.philip
      self.modules.homeManager.darwin
    ];
  };

  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.username = "philip";
    home.homeDirectory = "/Users/philip";

    home.stateVersion = "23.11";

    home.packages = with pkgs; [
      docker-client
      colima
      raycast
      keeweb
      lens
      bun
      devenv
      ghc
      wget
      biome
      gnused
      nixfmt
      nerd-fonts.jetbrains-mono
      glow
      typst
      typstyle
      mosh
    ];

    home.file = {
      ".config/ghostty/config".text = ''
        font-family = JetBrainsMono Nerd Font Mono
        font-size = 16
        theme = Kanagawa Wave
      '';
    };

    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      attachExistingSession = true;
    };

    programs.home-manager.enable = true;
  };

}
