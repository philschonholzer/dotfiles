{ ... }: {
  flake.modules.homeManager.editors = { pkgs, config, ... }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withRuby = false;
      withPython3 = false;
      sideloadInitLua = true;
      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = with pkgs; [
        nixfmt
        imagemagick
        websocat
        cargo
        lua
        lua-language-server
        stylua
        tinymist
        ghostscriptX
        marksman
        lsof
        tree-sitter
        statix
      ];
    };

    xdg.configFile = {
      "nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/nvim";
    };
  };
}
