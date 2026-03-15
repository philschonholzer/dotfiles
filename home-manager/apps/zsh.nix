{
  programs.zsh = {
    enable = true;

    # Re-source Nix after /etc/profile potentially resets PATH
    # This is needed on Fedora/RHEL where /etc/zprofile sources /etc/profile
    profileExtra = ''
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';

    initContent = ''
      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';

    syntaxHighlighting = {
      enable = true;
    };

    historySubstringSearch.enable = true;

    # zprof.enable = true; # Profile zsh startup (what causes long startup times)

    shellAliases = {
      pn = "pnpm";
      p = "pnpm";
      mysql-proxy-apptiva = "cloud-sql-proxy kubernetes-283408:europe-west6:apptiva-mysql-8-common -p 3308";
      v = "c && vi .";
      nrs = "sudo nixos-rebuild switch --flake .#$HOST";
      lg = "lazygit";
    };
  };
}
