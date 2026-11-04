{ inputs, ... }:
{
  flake.modules.homeManager.base = {
    imports = [ inputs.trello-tray.homeManagerModules.default ];

    programs.trello-tray = {
      enable = true;
      settings = {
        refresh_interval = 300;
        boards = [
          {
            board = "Philip";
            list = "In Arbeit";
          }
          {
            board = "Apptiva-Kreis";
            list = "In Arbeit";
          }
          {
            board = "App-Entwicklung";
            list = "In Arbeit";
          }
          {
            board = "Marketing & Akquise";
            list = "In Arbeit";
          }
          {
            board = "Offerten";
            list = "Potential";
          }
          {
            board = "HSLU Curriculum Configurator";
            list = "In Arbeit";
          }
          {
            board = "Suva Cycle & Slope Track";
            list = "In Umsetzung";
          }
          {
            board = "HKN-Vermarktung";
            list = "In Arbeit";
          }
          {
            board = "FleetAssistant";
            list = "In Arbeit";
          }
          {
            board = "Administratives";
            list = "In Arbeit";
          }
          {
            board = "Apptiva Governance";
            list = "In Arbeit";
          }
          {
            board = "injoi Produktentwicklung";
            list = "In Arbeit";
          }
          {
            board = "Ki-Business etablieren";
            list = "⚙️ In Arbeit";
          }
        ];
      };
    };
  };
}
