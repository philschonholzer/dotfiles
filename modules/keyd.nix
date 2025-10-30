{
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        main = {
          j = "overload(meta, j)";
          f = "overload(meta, f)";
          k = "overload(shift, k)";
          d = "overload(shift, d)";
          l = "overload(control, l)";
          s = "overload(control, s)";
          semicolon = "overload(alt, semicolon)";
          a = "overload(alt, a)";
        };
      };
    };
  };
}
