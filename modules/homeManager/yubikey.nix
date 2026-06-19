{ ... }: {
  flake.modules.homeManager.yubikey = { pkgs, ... }: {
    home = {
      packages = with pkgs; [
        yubikey-manager
        yubioath-flutter
        age-plugin-yubikey
        age
        pinentry-gnome3
      ];

      sessionVariables = {
        SOPS_AGE_KEY_FILE = "${../../home-manager/apps/age-yubikey-identity-94f838f0.txt}";
      };
    };

    services.yubikey-agent.enable = true;
  };
}
