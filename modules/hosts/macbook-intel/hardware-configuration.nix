{
  flake.modules.nixos.macbook-intel =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/hardware/network/broadcom-43xx.nix")
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
      boot = {

        initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "usbhid"
          "uas"
          "usb_storage"
          "sd_mod"
        ];
        initrd.kernelModules = [ ];
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/2fb64878-2876-463c-9ff6-611fa6f00db4";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/CDC0-367F";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/2cad85a5-b50c-4fc9-94ba-261307a1a6dd"; }
      ];

      networking.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
