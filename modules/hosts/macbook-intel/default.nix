{
  flake.modules.nixos.macbook-intel = {
    networking.hostName = "macbook-intel";

    home-manager.users.philip = {
      home.stateVersion = "25.05";

      services.niri = {
        configFile = ./niri.kdl;
      };
    };
  };
}
