{ inputs, lib, ... }: {
  flake.overlays = {
    modifications = _final: _prev: {
      # morgen overlay removed: 4.0.6 no longer has the getGPUInfo CPU bug that required patching
    };

    # When applied, the unstable nixpkgs set (declared in the flake inputs) will
    # be accessible through 'pkgs.unstable'
    unstable-packages = final: _prev: {
      unstable =
        let
          system = final.stdenv.hostPlatform.system;
          isAmd = system == "x86_64-linux";
        in
        import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          config.rocmSupport = isAmd;
          overlays = lib.optionals isAmd [
            # Apply ROCm support to unstable.blender for AMD GPU compute
            (_ufinal: uprev: {
              blender = uprev.blender.override {
                rocmSupport = true;
              };
            })
          ];
        };
    };
  };
}
