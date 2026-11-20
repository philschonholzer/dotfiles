{ inputs, ... }:
{
  flake.modules.homeManager.nixos =
    { osConfig, ... }:
    {
      imports = [ inputs.self.modules.homeManager.linux ];

      # Home Manager's portal discovery directory replaces the system directory.
      xdg.portal.extraPortals = osConfig.xdg.portal.extraPortals;
    };

  flake.modules.homeManager.genericLinux = {
    imports = [ inputs.self.modules.homeManager.linux ];
  };
}
