{ inputs, ... }: {
  flake.overlays = {
    modifications = _final: _prev: {
      # morgen overlay removed: 4.0.6 no longer has the getGPUInfo CPU bug that required patching
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
          (_ufinal: uprev: {
            blender = uprev.blender.override {
              rocmSupport = true;
            };
          })
          # Enable OAuth credentials (Microsoft, Google) for aerion.
          # The nixpkgs package defaults to withOAuth = false; override to true
          # so aerion-creds is symlinked into $out/bin/ at build time.
          (_ufinal: uprev: {
            aerion = uprev.aerion.override { withOAuth = true; };
          })
        ];
      };
    };
  };
}
