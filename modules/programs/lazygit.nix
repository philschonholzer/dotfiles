{ ... }: {
  flake.modules.homeManager.base = {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          sidePanelWidth = 0.2;
        };
        git = {
          diffRenderers = [
            {
              colorArgs = "always";
              command = "delta --dark --paging=never --syntax-theme base16-256 -s";
            }
          ];
        };
      };
    };
  };
}
