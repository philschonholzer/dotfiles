{ inputs, ... }:
let
  inherit (inputs) nixpkgs;
  supportedSystems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
in
{
  flake.lib.pkgsFor = nixpkgs.lib.genAttrs supportedSystems (
    system:
    import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-39.8.10" ];
      };
      overlays = builtins.attrValues inputs.self.overlays;
    }
  );

  flake.lib.nixgl =
    { pkgs, lib }:
    let
      glWrapper = pkgs.nixgl.nixGLMesa;
    in
    {
      wrapGL =
        pkg: binaries:
        pkgs.symlinkJoin {
          name = "${pkg.name}-nixgl-wrapped";
          paths = [ pkg ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = lib.concatMapStringsSep "\n" (bin: ''
            rm "$out/bin/${bin}"
            makeWrapper "${glWrapper}/bin/nixGLMesa" "$out/bin/${bin}" \
              --add-flags "${pkg}/bin/${bin}"
          '') (lib.toList binaries);
          inherit (pkg) meta;
          passthru.unwrapped = pkg;
        };

      wrapGLExec =
        binName: executable: extraArgs:
        pkgs.writeShellScriptBin binName ''
          exec ${glWrapper}/bin/nixGLMesa ${executable} ${
            lib.concatStringsSep " " (builtins.map (a: "'${a}'") extraArgs)
          } "$@"
        '';
    };
}
