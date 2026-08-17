{
  flake.modules.homeManager.base = {
    services.espanso = {
      enable = true;
      matches = {
        base = {
          matches = [
            {
              trigger = ":pa";
              replace = "philip.schoenholzer@apptiva.ch";
            }
            {
              trigger = ":ps";
              replace = "philip@schoenholzer.com";
            }
            {
              trigger = ":cal15";
              replace = "https://cal.com/phisch/15min";
            }
            {
              trigger = ":cal30";
              replace = "https://cal.com/phisch/30min";
            }
            {
              trigger = ":hello";
              replace = "line1\nline2";
            }
            {
              regex = ":hi(?P<person>.*)\\.";
              replace = "Hi {{person}}!";
            }
          ];
        };
        global_vars = {
          global_vars = [
            {
              name = "currentdate";
              type = "date";
              params = {
                format = "%d.%m.%Y";
              };
            }
            {
              name = "currenttime";
              type = "date";
              params = {
                format = "%R";
              };
            }
          ];
        };
      };
    };
  };
}
