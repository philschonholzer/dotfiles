{ ... }:
{
  flake.modules.homeManager.x86_64 =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.unstable.eloquent ];
    };

  flake.modules.homeManager.aarch64 =
    { lib, pkgs, ... }:
    let
      # LanguageTool's bundled Hunspell library does not support aarch64-linux.
      # JNA looks for libhunspell.so, while Nix installs libhunspell-1.7.so.
      hunspellLibrary = pkgs.runCommand "eloquent-hunspell" { } ''
        mkdir -p "$out/lib"
        ln -s ${lib.getLib pkgs.hunspell}/lib/libhunspell-1.7.so "$out/lib/libhunspell.so"
      '';
      eloquent = pkgs.unstable.eloquent.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace src/languagetool.js \
            --replace-fail '"java",' '"java", "-Djna.library.path=${hunspellLibrary}/lib",'
        '';
      });
    in
    {
      home.packages = [ eloquent ];
    };
}
