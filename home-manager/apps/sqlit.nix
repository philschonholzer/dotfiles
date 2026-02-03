{sqlit-pkg, ...}: let
  sqlit-relaxed = sqlit-pkg.overridePythonAttrs (old: {
    pythonRelaxDeps = (old.pythonRelaxDeps or []) ++ ["textual"];
  });
in {
  home.packages = [sqlit-relaxed];
}
