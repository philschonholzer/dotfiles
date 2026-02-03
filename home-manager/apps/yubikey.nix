{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      yubikey-manager # offizielles yubikey CLI tool
      yubioath-flutter # offizielles yubikey GUI
      age-plugin-yubikey # ausführen um age einzurichten, braucht es danach aber auch noch
      age
      pinentry-gnome3 # needed by yubikey-agent for PIN prompts
    ];

    sessionVariables = {
      SOPS_AGE_KEY_FILE = "${./key.txt}"; # output von age-plugin-yubikey als Datei ins nix-repo einchecken und hier referenzieren
    };
  };

  services.yubikey-agent.enable = true; # braucht es nur für ssh
}
