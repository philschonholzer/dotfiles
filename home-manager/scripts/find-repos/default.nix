{...}: {
  home.file = {
    "repo-preview.sh" = {
      source = ./repo-preview.sh;
      executable = true;
    };
  };

  programs.zsh.initContent = ''
    c() {
      local dir
      dir=$(fd -H -d 3 -t d -g '.git' ~/dev ~/nixos-config --exec dirname | \
            awk -F'/' '{short=substr($0, index($0,$5)); print short "\t" $0}' | \
            fzf --with-nth=1 \
                --preview '~/repo-preview.sh {2}' | \
            cut -f2)
      if [ -z "$dir" ]; then
        echo "No selection made."
        return 1
      fi
      cd "$dir" || return
    }
  '';
}
