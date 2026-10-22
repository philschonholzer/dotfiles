{ ... }:
{
  flake.modules.nixos.beelink = { lib, ... }: {
    services.printing.browsed.enable = false;

    hardware.printers.ensureDefaultPrinter = "HP_M277dw";
    hardware.printers.ensurePrinters = [
      {
        name = "HP_M277dw";
        description = "HP Color LaserJet MFP M277dw";
        deviceUri = "ipp://NPICD3D8A.local:631/ipp/print";
        model = "everywhere";
        ppdOptions.printer-is-shared = "false";
      }
    ];

    # IPP Everywhere setup needs a reachable printer. Run it outside activation
    # and retry periodically so an offline printer cannot fail a system switch.
    systemd.services.ensure-printers = {
      wantedBy = lib.mkForce [ ];
      restartIfChanged = false;
      serviceConfig = {
        RemainAfterExit = lib.mkForce false;
        # lpadmin exits 1 on connection errors. Keep its log, but let the timer
        # retry instead of leaving a failed unit that activation would report.
        SuccessExitStatus = [ 1 ];
      };
    };

    systemd.timers.ensure-printers = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitInactiveSec = "5min";
      };
    };
  };
}
