{ ... }: {
  flake.modules.homeManager.base = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        gcloud = {
          disabled = true;
        };
        custom.pkgmanager = {
          command = ''if [ -f pnpm-lock.yaml ]; then echo "pnpm"; elif [ -f package-lock.json ]; then echo "npm"; elif [ -f yarn.lock ]; then echo "yarn"; elif [ -f bun.lockb ] || [ -f bun.lock ]; then echo "bun"; fi'';
          when = "test -f package.json";
          symbol = "📦 ";
          style = "bold blue";
          format = "[$symbol$output]($style) ";
        };
      };
    };
  };
}
