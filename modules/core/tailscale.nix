{ ... }: {
  flake.modules.nixos.base = { pkgs, ... }: {
    services.tailscale.enable = true;

    systemd.services.tailscale-file-get = {
      description = "Tailscale Taildrop file receiver";
      after = [
        "tailscaled.service"
        "tailscaled-autoconnect.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.tailscale}/bin/tailscale file get --loop /home/philip/Downloads";
        Restart = "on-failure";
        User = "philip";
      };
    };
  };
}
