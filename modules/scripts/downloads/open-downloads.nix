{ ... }: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      open-downloads = pkgs.writeShellApplication {
        name = "open-downloads";
        runtimeInputs = with pkgs; [
          fd
          xdg-utils
          libnotify
          coreutils
          wl-clipboard
        ];
        text = builtins.readFile ./open-downloads.sh;
      };
    in
    {
      home.packages = [ open-downloads ];
    };
}
