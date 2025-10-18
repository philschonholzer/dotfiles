inputs: {
  pkgs,
  lib,
  ...
}: {
  imports = [
    (import ../home-manager/desktop-manager inputs)
    ../home-manager/apps
    ../home-manager/scripts
  ];

  home = {
    username = "philip";
    homeDirectory = "/home/philip";
    stateVersion = "25.05";

    packages = with pkgs; [
      unstable.opencode
      unstable.blender
      unstable.morgen
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
      gnome-calculator
      wofi-emoji
      sushi
      handbrake
      localsend
      inkscape
      gftp
      parsec-bin
    ];
  };
}
