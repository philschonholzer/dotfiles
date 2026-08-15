{ ... }:
{
  flake.modules.nixos.base =
    { ... }:
    let
      nasHost = "NAS.local";
      user = "philip";
      baseDir = "/home/${user}/QNAP";

      mkNfsMount = share: {
        device = "${nasHost}:/${share}";
        fsType = "nfs";
        options = [
          "nfsvers=4"
          "soft"
          "timeo=30"
          "nofail"
          "noauto"
          "x-systemd.automount"
          "x-systemd.mount-timeout=10s"
          "x-systemd.idle-timeout=10min"
          "_netdev"
        ];
      };
    in
    {
      boot.supportedFilesystems = [ "nfs" ];

      systemd.tmpfiles.rules = [ "d ${baseDir} 0755 ${user} users -" ];

      fileSystems."${baseDir}/Videos" = mkNfsMount "Videos";
      fileSystems."${baseDir}/Scans" = mkNfsMount "Scans";
      fileSystems."${baseDir}/Photos" = mkNfsMount "Photos";
      fileSystems."${baseDir}/Multimedia" = mkNfsMount "Multimedia";
      fileSystems."${baseDir}/homes" = mkNfsMount "homes";
      fileSystems."${baseDir}/home" = mkNfsMount "homes/${user}";
      fileSystems."${baseDir}/Download" = mkNfsMount "Download";
    };
}
