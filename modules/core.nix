{ inputs, ... }: {
  flake.modules.nixos.core = { pkgs, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://cache.garnix.io"
        "https://noctalia.cachix.org"
      ];
      extra-trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
      auto-optimise-store = true;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    nixpkgs = {
      overlays = [
        inputs.self.overlays.modifications
        inputs.self.overlays.unstable-packages
      ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-39.8.10" ];
      };
    };

    users.users.philip = {
      isNormalUser = true;
      description = "Philip Schoenholzer";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "input"
      ];
      shell = pkgs.zsh;
    };

    time.timeZone = "Europe/Zurich";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_CH.UTF-8";
        LC_IDENTIFICATION = "de_CH.UTF-8";
        LC_MEASUREMENT = "de_CH.UTF-8";
        LC_MONETARY = "de_CH.UTF-8";
        LC_NAME = "de_CH.UTF-8";
        LC_NUMERIC = "de_CH.UTF-8";
        LC_PAPER = "de_CH.UTF-8";
        LC_TELEPHONE = "de_CH.UTF-8";
        LC_TIME = "de_CH.UTF-8";
      };
    };

    programs = {
      zsh.enable = true;
      appimage.enable = true;
    };

    environment.systemPackages = with pkgs; [
      neovim
      wget
      curl
      gcc
      unzip
    ];

    environment.variables.EDITOR = "nvim";

    virtualisation.docker.enable = true;

    system.stateVersion = "24.11";

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit (inputs) noctalia nix-colors;
        wlavu = inputs.wlavu.packages.${pkgs.stdenv.hostPlatform.system}.default;
        dictation = inputs.dictation;
        sqlit-pkg = inputs.sqlit.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
      users.philip = {
        imports = [
          inputs.self.modules.homeManager.git
          inputs.self.modules.homeManager.zsh
          inputs.noctalia.homeModules.default
          inputs.nix-colors.homeManagerModules.default
          (if pkgs.stdenv.isAarch64 then ../home-manager/arm.nix else ../home-manager/x86.nix)
        ];
      };
    };
  };
}
