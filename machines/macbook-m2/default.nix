{...}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../../modules/keyd.nix
  ];
}
