{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        sidePanelWidth = 0.2;
      };
      git = {
        pagers = [
          {
            colorArgs = "always";
            pager = "delta --dark --paging=never --syntax-theme base16-256 -s";
          }
        ];
      };
    };
  };
}
