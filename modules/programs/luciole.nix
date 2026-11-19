{ inputs, ... }:
{
  flake.modules.homeManager.linux =
    { config, lib, ... }:
    {
      imports = [ inputs.luciole.homeModules.default ];

      programs.luciole.enable = true;

      xdg.mimeApps.defaultApplications."inode/directory" = "dev.noctalia.luciole.desktop";

      xdg.portal = {
        enable = true;
        extraPortals = [ config.programs.luciole.package ];
        config = lib.genAttrs [ "common" "umbriel" "niri" ] (_: {
          "org.freedesktop.impl.portal.FileChooser" = [
            "luciole"
            "gtk"
          ];
        });
      };

      # Fedora's session bus does not discover activation files in the Nix profile.
      xdg.dataFile."dbus-1/services/org.freedesktop.impl.portal.desktop.luciole.service".source =
        "${config.programs.luciole.package}/share/dbus-1/services/org.freedesktop.impl.portal.desktop.luciole.service";
    };

  flake.modules.nixos.base.services.gvfs.enable = true;
}
