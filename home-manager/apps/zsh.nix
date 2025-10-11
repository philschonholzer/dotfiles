{...}: {
  programs.zsh = {
    enable = true;

    syntaxHighlighting = {
      enable = true;
    };

    historySubstringSearch.enable = true;

    shellAliases = {
      pn = "pnpm";
      p = "pnpm";
      mysql-proxy-apptiva = "cloud-sql-proxy kubernetes-283408:europe-west6:apptiva-mysql-8-common -p 3308";
      v = "c && vi .";
      nrs = "sudo nixos-rebuild switch";
      lg = "lazygit";
    };
  };
}
