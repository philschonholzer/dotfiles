{ ... }: {
  flake.modules.homeManager = {
    aarch64 = { pkgs, ... }: {
      home.packages = with pkgs; [
        slacky
      ];
    };

    x86_64 = { pkgs, ... }: {
      home.packages = with pkgs; [
        morgen
        slack
        freelens-bin
        unstable.onlyoffice-desktopeditors
      ];
    };

    nixos = { pkgs, ... }: {
      home.packages = with pkgs; [
        unstable.blender
        ffmpeg-full
        xwayland-satellite
      ];
    };

    base = { pkgs, ... }: {
      home.packages = with pkgs; [

        # Utils
        alacritty
        bitwarden-desktop
        telegram-desktop
        gcr # displaying certificates and crypto UI, accessing key stores
        keymapp
        p7zip
        fastfetch
        gnome-calculator
        gftp
        parsec-bin
        wl-clipboard

        # Desktop
        sushi

        # Dev
        unstable.opencode
        unstable.pi-coding-agent
        nodejs_24
        pnpm
        dbeaver-bin
        pandoc
        python3
        mysql84
        file
        jq
        (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
        google-cloud-sql-proxy
        poedit

        # Office
        libreoffice
        papers
        xournalpp

        # Image editor and viewers
        loupe # modern image viewer
        unstable.gthumb # image viewer with some editing features
        pinta # simple paint program
        rapidraw # Raw editor
        imv # cli image viewer, like mpv for images
        inkscape # svg editor

        # Video
        kdePackages.kdenlive
        handbrake
        cameractrls-gtk4
        gpu-screen-recorder
      ];

    };
  };
}
