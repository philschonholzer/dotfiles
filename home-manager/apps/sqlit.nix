{
  sqlit-pkg,
  pkgs,
  ...
}: let
  # Override sqlit to relax the textual dependency check
  sqlit-relaxed = sqlit-pkg.overridePythonAttrs (old: {
    pythonRelaxDeps = (old.pythonRelaxDeps or []) ++ ["textual"];
  });
in {
  home.packages = [sqlit-relaxed];
}
