{ inputs, ... }:
{
  flake.modules.homeManager.nixos = {
    imports = [ inputs.self.modules.homeManager.linux ];
  };

  flake.modules.homeManager.genericLinux = {
    imports = [ inputs.self.modules.homeManager.linux ];
  };
}
