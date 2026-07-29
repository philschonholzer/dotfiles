{ ... }: {
  flake.modules.homeManager.base = { pkgs, ... }: {
    programs.mpv = {
      enable = true;

      package = pkgs.mpv.override {
        mpv-unwrapped = pkgs.mpv-unwrapped.override { waylandSupport = true; };
        scripts = [ pkgs.mpvScripts.modernz ];
      };

      scriptOpts.modernz = {
        osc_color = "#000000";
      };
    };
  };
}
