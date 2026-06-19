{ ... }: {
  flake.modules.homeManager.niri = { config, lib, ... }:
  let
    cfg = config.services.niri;
  in
  {
    options.services.niri = {
      enable = lib.mkEnableOption "Niri window manager (home-manager)";

      configFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to the machine-specific Niri config override file (should be in the machine's directory)";
      };
    };

    config = lib.mkIf cfg.enable {
      xdg.configFile = {
        "niri/config.kdl".text = "include \"niri-base.kdl\"\n" + builtins.readFile cfg.configFile;
        "niri/niri-base.kdl".text = builtins.readFile ./niri-base.kdl;
      };
    };
  };
}
