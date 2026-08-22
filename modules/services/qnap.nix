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
      fileSystems = {
        "${baseDir}/Videos" = mkNfsMount "Videos";
        "${baseDir}/Scans" = mkNfsMount "Scans";
        "${baseDir}/Photos" = mkNfsMount "Photos";
        "${baseDir}/Multimedia" = mkNfsMount "Multimedia";
        "${baseDir}/homes" = mkNfsMount "homes";
        "${baseDir}/home" = mkNfsMount "homes/${user}";
        "${baseDir}/Download" = mkNfsMount "Download";
      };
    };
}
