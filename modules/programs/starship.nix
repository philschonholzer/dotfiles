{ ... }: {
  flake.modules.homeManager.philip = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        gcloud = {
          disabled = true;
        };
      };
    };
  };
}
