{
  flake.modules.nixos.macbook-intel = {
    home-manager.users.philip = {
      services.niri = {
        configFile = ./niri.kdl;
      };
    };
  };
}
