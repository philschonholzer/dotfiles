{ ... }: {
  flake.modules.nixos.base = { lib, ... }: {
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
        ];
        allowedUDPPorts = [ ];
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
