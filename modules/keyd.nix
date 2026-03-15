{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "tab";
          tab = "esc";
          esc = "capslock";
          j = "lettermod(meta, j, 150, 200)";
          f = "lettermod(meta, f, 150, 200)";
          k = "lettermod(shift, k, 150, 200)";
          d = "lettermod(shift, d, 150, 200)";
          l = "lettermod(control, l, 150, 200)";
          s = "lettermod(control, s, 150, 200)";
          semicolon = "lettermod(alt, semicolon, 150, 200)";
          a = "lettermod(alt, a, 150, 200)";
        };
      };
    };
  };
}
