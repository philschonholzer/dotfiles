{...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        sidePanelWidth = 0.2;
      };
      git = {
        paging = {
          colorArgs = "always";
          pager = "delta --dark --paging=never --syntax-theme base16-256 -s";
        };
      };
    };
  };
}
