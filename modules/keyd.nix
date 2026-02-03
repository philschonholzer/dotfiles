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
          j = "overloadt2(meta, j, 200)";
          f = "overloadt2(meta, f, 200)";
          k = "overloadt2(shift, k, 200)";
          d = "overloadt2(shift, d, 200)";
          l = "overloadt2(control, l, 200)";
          s = "overloadt2(control, s, 200)";
          semicolon = "overloadt2(alt, semicolon, 200)";
          a = "overloadt2(alt, a, 200)";
        };
      };
    };
  };
}
