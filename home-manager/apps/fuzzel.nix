{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        lines = 10;
        prompt = "  ";
        inner-pad = 16;
        width = 30;
        font = "Sans\:size=18";
        line-height = 30;
      };

      colors = {
        background = "2e3440ff"; # Background - Nord0 (Darkest polar night)
        text = "d8dee9ff"; # Text - Nord4 (Snow storm)
        prompt = "4c566aff"; # Prompt - Nord3 (Lighter polar night - lower contrast)
        placeholder = "4c566aff"; # Placeholder - Nord3 (Lighter polar night)
        input = "8fbcbbff"; # Input text - Nord7 (Frost - better contrast)
        match = "ebcb8bff"; # Match highlighting - Nord13 (Aurora yellow)
        selection = "3b4252ff"; # Selection background - Nord1 (Polar night)
        selection-text = "eceff4ff"; # Match in selection - Nord15 (Aurora purple)
        counter = "4c566aff"; # Counter - Nord3 (Lighter polar night)
        border = "4c566aff"; # Border - Nord3 (Lightest polar night)
      };

      border = {
        width = 1;
        radius = 12;
      };
    };
  };
}
