{ ... }: {
  flake.modules.homeManager.browsers = { config, ... }: {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
  };
}
