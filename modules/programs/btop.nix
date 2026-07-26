{ ... }: {
  flake.modules.homeManager.base = { pkgs, ... }: {
    programs.btop = {
      package = pkgs.btop-rocm;
      enable = true;
      settings = {
        vim_keys = true;
        proc_tree = true;
        proc_aggregate = true;
      };
    };
  };
}
