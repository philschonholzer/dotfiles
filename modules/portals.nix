{ pkgs, lib, ... }:
{
  xdg.portal = {
    enable = true;
    # Force this to resolve conflict between niri-autoselect-portal ("gtk;gnome")
    # and the nixpkgs niri module ("gnome;gtk") — functionally identical.
    config.niri.default = lib.mkForce "gnome;gtk";
  };

  # Enable niri-autoselect-portal for automatic screencasting
  services.niri-autoselect-portal.enable = true;
}
