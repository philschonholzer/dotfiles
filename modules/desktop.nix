{ inputs, ... }: {
  flake.modules.nixos.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.services.niri;
    in
    {
      imports = [
        inputs.niri-autoselect-portal.nixosModules.default
        inputs.noctalia-greeter.nixosModules.default
      ];

      options.services.niri = {
        enable = lib.mkEnableOption "Niri window manager";
        enableSystemIntegration = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable system-level Niri integration (greetd, environment variables)";
        };
      };

      config = lib.mkMerge [
        (lib.mkIf cfg.enable {
          programs.niri = {
            enable = true;
            package = pkgs.niri;
          };
          environment.sessionVariables = lib.mkIf cfg.enableSystemIntegration {
            XDG_CURRENT_DESKTOP = "niri";
            XDG_SESSION_TYPE = "wayland";
            XDG_SESSION_DESKTOP = "niri";
            NIXOS_OZONE_WL = "1";
          };
        })
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
            niri.enable = true;
            greetd.settings.default_session.user = "philip";
          };
          programs = {
            seahorse.enable = true;
            nautilus-open-any-terminal = {
              enable = true;
              terminal = "ghostty";
            };
            noctalia-greeter.enable = true;
          };
          xdg.portal = {
            enable = true;
            config.niri.default = lib.mkForce "gnome;gtk";
          };
          services.niri-autoselect-portal.enable = true;
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
        }
      ];
    };
}
