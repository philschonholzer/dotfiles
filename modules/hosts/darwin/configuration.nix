{ inputs, ... }:
let
  inherit (inputs) self home-manager;
in
{
  flake.homeConfigurations.darwin = home-manager.lib.homeManagerConfiguration {
    pkgs = self.lib.pkgsFor."aarch64-darwin";
    modules = [
      self.modules.homeManager.base
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
      ".ssh/authorized_keys".text = ''
        ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPsgBnH6UaRLsah6JOfsnPUACYM3mFTzUzV/7Y03gkcp3hvCMtDioWQfsIVwL7XxBZjqIO3hLkuyNxbygQBKczE= YubiKey #34058449 PIV Slot 9a
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
