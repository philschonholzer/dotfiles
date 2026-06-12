{
  pkgs,
  outputs,
  lib,
  home-manager,
  noctalia,
  nix-colors,
  vicinae,
  wlavu,
  dictation,
  sqlit-pkg,
  niri-autoselect-portal,
  ...
}:
{
  imports = [
    ../modules
    home-manager.nixosModules.home-manager
    niri-autoselect-portal.nixosModules.default
    {
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit
            noctalia
            nix-colors
            wlavu
            dictation
            sqlit-pkg
            ;
        };
        users.philip = {
          imports = [
            noctalia.homeModules.default
            nix-colors.homeManagerModules.default
            vicinae.homeManagerModules.default
            (if pkgs.stdenv.isAarch64 then ../home-manager/arm.nix else ../home-manager/x86.nix)
          ];
        };
      };
    }
  ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    keyboard.zsa.enable = true;
    xpadneo.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Privacy = "device";
          JustWorksRepairing = "always";
          Class = "0x000100";
          FastConnectable = "true";
        };
      };
    };

    # Enable hardware graphics acceleration
    graphics = {
      enable = true;
      enable32Bit = pkgs.stdenv.hostPlatform.isx86_64; # Only for x86_64 systems
      extraPackages =
        with pkgs;
        lib.optionals stdenv.hostPlatform.isx86_64 [
          rocmPackages.clr.icd # ROCm/HIP runtime for AMD GPU compute (x86_64 only)
        ];
    };
  };

  networking = {
    hostName = lib.mkDefault "nixos";

    # Enable networking
    networkmanager.enable = true;

    # Static hostname for QNAP NAS
    # This ensures resolution works even for apps that don't use NSS (like browsers with c-ares)
    # If the QNAP IP changes, update it here or set a DHCP reservation in your router
    hosts = {
      "192.168.1.12" = [
        "NAS.local"
        "nas"
      ];
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    firewall.allowedTCPPorts = [
      8081
      53317
    ];
    firewall.allowedUDPPorts = [ 53317 ];
  };

  services = {
    blueman.enable = true;

    # Enable Avahi for .local hostname resolution (mDNS)
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };

    # Sound
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    power-profiles-daemon.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "altgr-intl";
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.gnome-keyring.enable = true;

    # Niri is now configured through modules/niri.nix
    niri = {
      enable = true;
      enableSystemIntegration = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    pam.services.login.enableGnomeKeyring = true;
    rtkit.enable = true;
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.philip = {
    isNormalUser = true;
    description = "Philip Schoenholzer";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  programs = {
    zsh.enable = true;
    appimage.enable = true;
    seahorse.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://vicinae.cachix.org"
      "https://cache.garnix.io"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];

    # Optimize storage
    # You can also manually optimize the store via:
    #    nix-store --optimise
    # Refer to the following link for more details:
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;
  };

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nixpkgs = {
    overlays = [
      # outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Allow unfree packages
    config.allowUnfree = true;
    # electron-39 is EOL but still required by bitwarden-desktop
    config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    noctalia.packages.${pkgs.system}.default
    neovim
    wget
    curl
    gcc
    alacritty
    fuzzel
    nautilus
    unzip
    gnome-keyring
    pwvucontrol
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  environment.variables.EDITOR = "nvim";

  # Environment variables for Niri are now configured through modules/niri.nix

  virtualisation.docker.enable = true;
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
