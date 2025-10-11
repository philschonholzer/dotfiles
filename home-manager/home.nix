inputs: {
  pkgs,
  lib,
  ...
}: {
  imports = [
    (import ./desktop-manager inputs)
    ./apps
    ./scripts
  ];

  home = {
    username = "philip";
    homeDirectory = "/home/philip";
    stateVersion = "25.05";

    packages = with pkgs; [
      unstable.opencode
      ente-auth
      bitwarden-desktop
      slack
      telegram-desktop
      nodejs_24
      pnpm
      wl-clipboard
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      google-cloud-sql-proxy
      keymapp
      lens
      p7zip
      insync
      insync-nautilus
      dbeaver-bin
      pinta
      papers
      xournalpp
      onlyoffice-desktopeditors
      pandoc
      neofetch
      mysql84
      kchat
      gcr
      ente-auth
      poedit
      morgen
      gnome-calculator
      wofi-emoji
      sushi
      handbrake
      localsend
      inkscape
      gftp
    ];
  };

  programs.firefox.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  services.hypridle.settings.listener = lib.mkForce [
    {
      timeout = 300;
      on-timeout = "loginctl lock-session";
    }
    {
      timeout = 900;
      on-timeout = "systemctl suspend";
    }
  ];
  services.cliphist.enable = true;
}
