{ ... }: {
  flake.modules.homeManager.amd = { pkgs, ... }: {
    programs.btop.package = pkgs.btop-rocm;
  };
  flake.modules.homeManager.base = { pkgs, ... }: {
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        proc_tree = true;
        proc_aggregate = true;
      };
    };
  };
}
