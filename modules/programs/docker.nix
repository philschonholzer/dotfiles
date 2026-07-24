{ ... }: {
  flake.modules.homeManager.genericLinux =
    { pkgs, lib, ... }:
    {
      programs.zsh = {
        initContent = ''
          # Fedora uses podman and docker needs to know the host
          export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock
        '';
      };
    };
}
