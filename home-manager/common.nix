{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./desktop-manager
    ./apps
    ./scripts
    ./niri.nix
  ];

  home = {
    username = "philip";
    homeDirectory = "/home/philip";
    stateVersion = "25.05";

    packages = with pkgs; [
      unstable.opencode
      unstable.blender
      ente-auth
      bitwarden-desktop
      telegram-desktop
      nodejs_24
      pnpm
      wl-clipboard
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      google-cloud-sql-proxy
      keymapp
      p7zip
      dbeaver-bin
      pinta
      papers
      xournalpp
      pandoc
      neofetch
      mysql84
      gcr
      poedit
      gnome-calculator
      wofi-emoji
      sushi
      handbrake
      localsend
      inkscape
      gftp
      parsec-bin
      xwayland-satellite
      jq
    ];
  };

  programs.alacritty.enable = true;
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        lines = 10;
        prompt = "  ";
        inner-pad = 16;
        width = 30;
        font = "Sans\:size=18";
        line-height = 30;
      };

      colors = {
        background = "2e3440ff"; # Background - Nord0 (Darkest polar night)
        text = "d8dee9ff"; # Text - Nord4 (Snow storm)
        prompt = "4c566aff"; # Prompt - Nord3 (Lighter polar night - lower contrast)
        placeholder = "4c566aff"; # Placeholder - Nord3 (Lighter polar night)
        input = "8fbcbbff"; # Input text - Nord7 (Frost - better contrast)
        match = "ebcb8bff"; # Match highlighting - Nord13 (Aurora yellow)
        selection = "3b4252ff"; # Selection background - Nord1 (Polar night)
        selection-text = "eceff4ff"; # Match in selection - Nord15 (Aurora purple)
        counter = "4c566aff"; # Counter - Nord3 (Lighter polar night)
        border = "4c566aff"; # Border - Nord3 (Lightest polar night)
      };

      border = {
        width = 1;
        radius = 12;
      };
    };
  };

  # Fonts
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["JetBrainsMono Nerd Font"];
    };
  };

  # Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.swaylock.enable = true;
  services.mako = {
    enable = true;

    settings = {
      background-color = "#${config.colorScheme.palette.base00}";
      text-color = "#${config.colorScheme.palette.base05}";
      border-color = "#${config.colorScheme.palette.base04}";
      progress-color = "#${config.colorScheme.palette.base0D}";

      width = 420;
      height = 110;
      padding = "10";
      margin = "10";
      border-size = 2;
      border-radius = 0;

      anchor = "top-right";
      layer = "overlay";

      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;
      sort = "-time";

      group-by = "app-name";

      actions = true;

      format = "<b>%s</b>\\n%b";
      markup = true;
    };
  };
}
