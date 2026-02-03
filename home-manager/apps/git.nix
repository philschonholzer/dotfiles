{ ... }:
{
  programs.git = {
    enable = true;
    ignores = [
      "*~"
      ".DS_Store"
      "/.direnv"
    ];
    settings = {
      user = {
        email = "philip.schoenholzer@apptiva.ch";
        name = "Philip Schönholzer";
      };
      core = {
        # editor = "code --wait";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
