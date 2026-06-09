# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  #   additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # Fix morgen 4.0.4 unhandled GPU info rejection in Sentry that causes 100% CPU
    morgen = prev.morgen.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [final.asar];
      postFixup =
        (oldAttrs.postFixup or "")
        + ''
          asar extract $out/opt/Morgen/resources/app.asar $out/opt/Morgen/resources/app
          substituteInPlace $out/opt/Morgen/resources/app/dist/main.js \
            --replace-fail \
              'ee.app.getGPUInfo(e.infoLevel)' \
              'ee.app.getGPUInfo(e.infoLevel).catch(()=>({gpuDevice:[]}))'
          asar pack $out/opt/Morgen/resources/app $out/opt/Morgen/resources/app.asar
          rm -rf $out/opt/Morgen/resources/app
        '';
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
      config.rocmSupport = true;
      overlays = [
        # Apply ROCm support to unstable.blender for AMD GPU compute
        (ufinal: uprev: {
          blender = uprev.blender.override {
            rocmSupport = true;
          };
        })
      ];
    };
  };
}
