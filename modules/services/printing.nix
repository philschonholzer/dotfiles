{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      services.printing.enable = true;

      # Autodiscovery of network printers via mDNS/DNS-SD
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      # HP printer/scanner support
      hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.hplipWithPlugin ];
      };

      users.users.philip.extraGroups = [
        "scanner"
        "lp"
      ];
    };
}
