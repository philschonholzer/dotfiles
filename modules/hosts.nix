{ inputs, ... }:
let
  inherit (inputs)
    self
    nixpkgs
    nixpkgs-unstable
    home-manager
    nix-colors
    noctalia
    wlavu
    dictation
    sqlit
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
      overlays = builtins.attrValues (
        import ../overlays.nix {
          inputs = { inherit nixpkgs-unstable; };
        }
      );
    }
  );
in
{
  flake.overlays = import ../overlays.nix {
    inputs = { inherit nixpkgs-unstable; };
  };

  flake.nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.core
      self.modules.nixos.desktop
      self.modules.nixos.hardware
      self.modules.nixos.network
      self.modules.nixos.security
      self.modules.nixos.apps
      ../machines/beelink
      { networking.hostName = "beelink"; }
    ];
  };

  flake.nixosConfigurations.macbook-intel = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.core
      self.modules.nixos.desktop
      self.modules.nixos.hardware
      self.modules.nixos.network
      self.modules.nixos.security
      self.modules.nixos.apps
      ../machines/macbook-intel
      { networking.hostName = "macbook-intel"; }
    ];
  };

  flake.homeConfigurations.macbook-m2 = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor."aarch64-linux";
    extraSpecialArgs = {
      inherit
        nix-colors
        noctalia
        ;
      wlavu = wlavu.packages."aarch64-linux".default;
      dictation-pkg = dictation.packages."aarch64-linux";
      sqlit-pkg = sqlit.packages."aarch64-linux".default;
    };
    modules = [
      self.modules.homeManager.git
      self.modules.homeManager.zsh
      self.modules.homeManager.direnv
      self.modules.homeManager.fd
      self.modules.homeManager.fzf
      self.modules.homeManager.ripgrep
      self.modules.homeManager.eza
      self.modules.homeManager.starship
      self.modules.homeManager.btop
      self.modules.homeManager.lazygit
      self.modules.homeManager.lazydocker
      self.modules.homeManager.npm
      self.modules.homeManager.chromium
      self.modules.homeManager.firefox
      self.modules.homeManager.nvim
      self.modules.homeManager.opencode
      self.modules.homeManager.qnap
      self.modules.homeManager.vnc
      self.modules.homeManager.yubikey
      self.modules.homeManager.joplin
      self.modules.homeManager.rbw
      nix-colors.homeManagerModules.default
      noctalia.homeModules.default
      ../machines/macbook-m2
    ];
  };

  flake.homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor."aarch64-darwin";
    modules = [
      self.modules.homeManager.git
      ../machines/darwin.nix
    ];
  };
}
