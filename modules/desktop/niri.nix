{ inputs, ... }: {
  flake.modules.nixos.base =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.niri-autoselect-portal.nixosModules.default
      ];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };

      environment.sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "niri";
        NIXOS_OZONE_WL = "1";
      };

      services.greetd.settings.default_session.user = "philip";

      xdg.portal = {
        enable = true;
        config.niri.default = lib.mkForce "gnome;gtk";
      };

      services.niri-autoselect-portal.enable = true;
    };

  flake.modules.homeManager.philip = { lib, config, ... }: {
    options.services.niri.configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the machine-specific Niri config override file";
    };

    config.xdg.configFile = {
      "niri/config.kdl".text =
        "include \"niri-base.kdl\"\n"
        + builtins.readFile config.services.niri.configFile;
      "niri/niri-base.kdl".text = builtins.readFile ./niri-base.kdl;
    };
  };
}
