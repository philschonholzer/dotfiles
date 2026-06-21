{
  flake.modules.nixos.beelink = {
    home-manager.users.philip = {
      home.stateVersion = "25.05";
      
      services.niri = {
        configFile = ./niri.kdl;
      };
    };
  };
}
