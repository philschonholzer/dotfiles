{ ... }: {
  flake.modules.homeManager.genericLinux =
    { pkgs, ... }:
    let
      wrapped =
        pkgs.runCommand "ente-auth-wrapped"
          {
            buildInputs = [ pkgs.makeWrapper ];
          }
          ''
            mkdir -p $out/bin $out/share/applications $out/share/pixmaps
            makeWrapper ${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa $out/bin/enteauth \
              --add-flags "${pkgs.ente-auth}/bin/enteauth"
            cp -r ${pkgs.ente-auth}/share/applications/* $out/share/applications/
            cp -r ${pkgs.ente-auth}/share/pixmaps/* $out/share/pixmaps/
          '';
    in
    {
      home.packages = [ wrapped ];
    };

  flake.modules.homeManager.nixos = { pkgs, ... }: {
    home.packages = [ pkgs.ente-auth ];
  };

  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.ente-auth ];
  };
}
