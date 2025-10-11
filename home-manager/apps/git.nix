{...}: {
  programs.git = {
    enable = true;
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
