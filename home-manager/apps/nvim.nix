{
  pkgs,
  config,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaPackages = ps: [ps.magick];
    extraPackages = with pkgs; [
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
    ];
  };

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/nvim";
    "hypr/xdph.conf".text = ''
      screencopy {
        allow_token_by_default = true
      }
    '';
  };
}
