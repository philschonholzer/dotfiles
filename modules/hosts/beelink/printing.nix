{ ... }:
{
  flake.modules.nixos.beelink = {
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
  };
}
