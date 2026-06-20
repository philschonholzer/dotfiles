{
  flake.modules.nixos.beelink = {
    home-manager.users.philip = {
      services.niri = {
        configFile = ./niri.kdl;
      };
    };
  };
}
