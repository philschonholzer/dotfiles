{pkgs, ...}: {
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     xdg-desktop-portal-wlr = final.unstable.xdg-desktop-portal-wlr;
  #   })
  # ];

  xdg.portal = {
    enable = true;
    # wlr = {
    #   enable = true;
    #   settings = {
    #     screencast = {
    #       max_fps = 30;
    #       chooser_type = "dmenu";
    #       chooser_cmd = "${pkgs.bemenu}/bin/bemenu";
    #     };
    #   };
    # };

    # extraPortals = [];
    #
    # config.common.default = "wlr";
  };
}
