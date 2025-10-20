{pkgs, ...}: {
  omarchy = {
    full_name = "Philip Schönholzer";
    email_address = "philip.schoenholzer@apptiva.ch";
    theme = "nord";
    monitors = ["DP-3, 5120x2160, 0x0, 1.6"];
    exclude_packages = [
      pkgs.signal-desktop
      pkgs.chromium
    ];
  };
}

