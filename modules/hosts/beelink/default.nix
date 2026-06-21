{
  flake.modules.nixos.beelink = {
    networking.hostName = "beelink";

    home-manager.users.philip = {
      home.stateVersion = "25.05";

      services.niri = {
        configFile = ./niri.kdl;
      };
    };
  };
}
