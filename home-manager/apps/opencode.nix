{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    settings = {
      "permission" = {
        "bash" = {
          "*" = "allow";
          "nixos-rebuild *" = "deny";
          "nixos-rebuild *--dry-build*" = "allow";
          "git push*" = "deny";
        };
      };
    };
  };

  programs.zsh.shellAliases.oc = "opencode";
}
