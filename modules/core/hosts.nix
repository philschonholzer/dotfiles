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
        import ../../overlays.nix {
          inputs = { inherit nixpkgs-unstable; };
        }
      );
    }
  );

  # Home-manager modules shared across all configurations
  hmModules = [
    self.modules.homeManager.common-base
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
    self.modules.homeManager.ssh
    self.modules.homeManager.sqlit
    self.modules.homeManager.ghostty
    self.modules.homeManager.fuzzel
    self.modules.homeManager.affinity
    self.modules.homeManager.niri
    self.modules.homeManager.noctalia
    self.modules.homeManager.theme
    self.modules.homeManager.wlavu
    self.modules.homeManager.nmgui
    self.modules.homeManager.web-apps
    self.modules.homeManager.qutebrowser
    self.modules.homeManager.dictation
    self.modules.homeManager.kdrive
    self.modules.homeManager.table-plus
    self.modules.homeManager.find-repos
    self.modules.homeManager.focus-or-spawn
    self.modules.homeManager.niri-window-indicator
    self.modules.homeManager.open-downloads
    self.modules.homeManager.open-repo
    self.modules.homeManager.qutebrowser-profile
    self.modules.homeManager.trello-boards
  ] ++ [
    nix-colors.homeManagerModules.default
    noctalia.homeModules.default
  ];

  # Wraps HM modules into a NixOS module via home-manager.users.philip.imports
  hmModuleForNixos = { pkgs, ... }: {
    home-manager.users.philip.imports = hmModules ++ (
      if pkgs.stdenv.isAarch64
      then [ self.modules.homeManager.arm ]
      else [ self.modules.homeManager.common-nixos self.modules.homeManager.x86 ]
    );
  };
in
{
  flake.overlays = import ../../overlays.nix {
    inputs = { inherit nixpkgs-unstable; };
  };

  flake.nixosConfigurations.beelink = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.core
      self.modules.nixos.desktop
      self.modules.nixos.niri
      self.modules.nixos.hardware
      self.modules.nixos.network
      self.modules.nixos.security
      self.modules.nixos.apps
      hmModuleForNixos
      ../../machines/beelink
      { networking.hostName = "beelink"; }
    ];
  };

  flake.nixosConfigurations.macbook-intel = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.core
      self.modules.nixos.desktop
      self.modules.nixos.niri
      self.modules.nixos.hardware
      self.modules.nixos.network
      self.modules.nixos.security
      self.modules.nixos.apps
      self.modules.nixos.keyd
      hmModuleForNixos
      ../../machines/macbook-intel
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
    modules = hmModules ++ [
      self.modules.homeManager.arm
      self.modules.homeManager.keyd
      ../../machines/macbook-m2
    ];
  };

  flake.homeConfigurations."philip" = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgsFor."aarch64-darwin";
    modules = [
      self.modules.homeManager.git
      self.modules.homeManager.nvim
      ../../machines/darwin.nix
    ];
  };
}
