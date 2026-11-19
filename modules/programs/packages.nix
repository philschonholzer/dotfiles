{ ... }: {
  flake.modules.homeManager = {
    aarch64 = { pkgs, ... }: {
      home.packages = with pkgs; [
      ];
    };

    x86_64 = { pkgs, ... }: {
      home.packages = with pkgs; [
        morgen
        slack
        freelens-bin
        onlyoffice-desktopeditors # Stable still permits the GTK2 dependency.
        losslesscut-bin
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

        # Comm
        fractal # Matrix client
        (unstable.aerion.override { withOAuth = true; }) # Email client
        teams-for-linux
        linphonePackages.linphone-desktop

        # Utils
        rofimoji # unicode/emoji picker
        alacritty
        bitwarden-desktop
        telegram-desktop
        gcr # displaying certificates and crypto UI, accessing key stores
        keymapp
        p7zip
        fastfetch
        gftp
        parsec-bin
        wl-clipboard
        unstable.handy # text to speech
        wtype # used for handy
        gnome-decoder # QR Code generator/scanner
        file-roller
        rclone-browser
        restic-browser
        restic
        ncdu

        # Desktop
        sushi

        # Dev
        unstable.pi-coding-agent
        nodejs_24
        pnpm
        dbeaver-bin
        pandoc
        python3
        mysql84
        file
        jq
        (google-cloud-sdk.withExtraComponents [
          google-cloud-sdk.components.gke-gcloud-auth-plugin
          google-cloud-sdk.components.kubectl
        ])
        google-cloud-sql-proxy
        poedit
        (sqlit-tui.overridePythonAttrs (old: {
          dependencies = (old.dependencies or [ ]) ++ [ python3Packages.pymysql ];
          pythonImportsCheck = (old.pythonImportsCheck or [ ]) ++ [ "pymysql" ];
        }))

        # Office
        libreoffice
        papers
        xournalpp
        unstable.pdfcraft
        unstable.gridcraft
        unstable.wordcraft

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
      ];

      programs.spotify-player.enable = true;
    };
  };
}
