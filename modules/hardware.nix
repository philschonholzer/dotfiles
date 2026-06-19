{ ... }: {
  flake.modules.nixos.hardware = { pkgs, lib, ... }: {
    hardware = {
      keyboard.zsa.enable = true;
      xpadneo.enable = true;
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Privacy = "device";
            JustWorksRepairing = "always";
            Class = "0x000100";
            FastConnectable = "true";
          };
        };
      };
      graphics = {
        enable = true;
        enable32Bit = pkgs.stdenv.hostPlatform.isx86_64;
        extraPackages =
          with pkgs;
          lib.optionals stdenv.hostPlatform.isx86_64 [
            rocmPackages.clr.icd
          ];
      };
    };
  };
}
