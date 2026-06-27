{ ... }: {
  flake.modules.nixos.base = {
    programs.localsend.enable = true;
  };

  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.localsend ];
  };

  flake.modules.homeManager.genericLinux =
    { pkgs, ... }:
    let
      wrapped =
        pkgs.runCommand "localsend-wrapped"
          {
            buildInputs = [ pkgs.makeWrapper ];
          }
          ''
            mkdir -p $out/bin $out/share/applications $out/share/icons
            makeWrapper ${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa $out/bin/localsend_app \
              --add-flags "${pkgs.localsend}/bin/localsend_app"
            cp -r ${pkgs.localsend}/share/applications/* $out/share/applications/
            cp -r ${pkgs.localsend}/share/icons/* $out/share/icons/
          '';
    in
    {
      home.packages = [ wrapped ];
    };
}
