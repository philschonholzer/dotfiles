{ inputs, ... }: {
  flake.modules.nixos.base =
    { pkgs, lib, config, ... }:
    {
      imports = [
        inputs.noctalia-greeter.nixosModules.default
      ];

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
          terminal = "ghostty";
        };
        noctalia-greeter.enable = true;
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
