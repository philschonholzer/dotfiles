{ ... }: {
  flake.modules.homeManager.npm = { config, ... }: {
    home.file.".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.local/npm
    '';
    home.sessionPath = [
      "$HOME/.local/npm/bin"
    ];
  };
}
