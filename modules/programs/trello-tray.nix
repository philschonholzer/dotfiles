{ inputs, ... }:
{
  flake.modules.homeManager.base = {
    imports = [ inputs.trello-tray.homeManagerModules.default ];

    programs.trello-tray = {
      enable = true;
      settings = {
        refresh_interval = 300;
        boards = [
          "68be9b0f1fc535e7ccd511ed" # Administratives
          "691b47fc3caa30456b1fc511" # App-Entwicklung
          "5c9dda821ffcd73aabc27df3" # Apptiva Governance
          "554b19c8100473c683744b5f" # Apptiva-Kreis
          "5c9dda992a8f5355a44f96be" # FleetAssistant
          "6ad925421f0a56135dc1725b" # HKN-Vermarktung
          "6ad727c61133b3af0179625e" # HSLU Curriculum Configurator
          "60a225827f63ae64705f2317" # injoi Produktentwicklung
          "6ab28551cabf1bb70e4a29af" # Ki-Business etablieren
          "5a71cd7babc6de293847733a" # Marketing & Akquise
          "5a6b21e994faf8c383815879" # Offerten
          "6982f4e77cecd757fb985ed2" # Philip
          "58d0d2893916086356a3fc7f" # Suva Cycle & Slope Track
        ];
      };
    };
  };
}
