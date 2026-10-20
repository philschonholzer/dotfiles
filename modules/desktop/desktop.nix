{ ... }: {
  flake.modules.homeManager.base = { pkgs, lib, ... }: {
    xdg.desktopEntries."org.gnome.Settings" = lib.mkIf pkgs.stdenv.isLinux {
      name = "GNOME Settings";
      comment = "Configure GNOME settings";
      exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
      icon = "org.gnome.Settings";
      terminal = false;
      categories = [ "Settings" ];
      settings.Keywords = "Preferences;Control Center;";
    };
  };

  flake.modules.nixos.base =
    { pkgs, ... }:
    {

      services = {
        pipewire = {
          enable = true;
          audio.enable = true;
          alsa.enable = true;
          pulse.enable = true;
          jack.enable = true;
          wireplumber.enable = true;
        };
        pulseaudio.enable = false;
        power-profiles-daemon.enable = true;
        xserver.xkb = {
          layout = "us";
          variant = "altgr-intl";
        };
        desktopManager.gnome.enable = true;
        gnome.gnome-keyring.enable = true;
      };

      programs = {
        seahorse.enable = true;
        nautilus-open-any-terminal = {
          enable = true;
          terminal = "foot";
        };
      };

      xdg.portal.enable = true;

      environment.systemPackages = with pkgs; [
        alacritty
        fuzzel
        nautilus
        pwvucontrol
      ];

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
      ];
    };
}
