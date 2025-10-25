{...}: {
  programs.git = {
    enable = true;
    userEmail = "philip.schoenholzer@apptiva.ch";
    userName = "Philip Schönholzer";
    delta.enable = true;
    ignores = [
      "*~"
      ".DS_Store"
      "/.direnv"
    ];
    extraConfig = {
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
}
