{ ... }: {
  flake.modules.homeManager.apps = {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          lines = 10;
          inner-pad = 16;
          width = 30;
          font = "Sans:size=18";
          line-height = 30;
        };

        colors = {
          background = "2e3440ff";
          text = "d8dee9ff";
          prompt = "4c566aff";
          placeholder = "4c566aff";
          input = "8fbcbbff";
          match = "ebcb8bff";
          selection = "3b4252ff";
          selection-text = "eceff4ff";
          counter = "4c566aff";
          border = "4c566aff";
        };

        border = {
          width = 1;
          radius = 12;
        };
      };
    };
  };
}
