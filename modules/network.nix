{ ... }: {
  flake.modules.nixos.network = { lib, ... }: {
    networking = {
      hostName = lib.mkDefault "nixos";
      networkmanager.enable = true;
      hosts = {
        "192.168.1.12" = [
          "NAS.local"
          "nas"
        ];
      };
      firewall = {
        allowedTCPPorts = [
          8081
          53317
        ];
        allowedUDPPorts = [ 53317 ];
      };
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
