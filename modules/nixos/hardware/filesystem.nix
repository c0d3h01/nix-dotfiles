{
  config,
  lib,
  pkgs,
  ...
}: let
  rootFs = config.fileSystems."/".fsType;
  isXfs = rootFs == "xfs";
  isBtrfs = rootFs == "btrfs";
in {
  # Filesystem-specific packages
  environment.systemPackages = lib.mkMerge [
    (lib.mkIf isXfs [pkgs.xfsprogs])
    (lib.mkIf isBtrfs [pkgs.btrfs-progs])
  ];

  services.fstrim.enable = lib.mkDefault true;

  # XFS scrub service
  systemd.services.xfs-scrub = lib.mkIf isXfs {
    description = "XFS filesystem scrub for data integrity";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = "${pkgs.xfsprogs}/bin/xfs_scrub -v /";
    };
  };

  systemd.timers.xfs-scrub = lib.mkIf isXfs {
    enable = true;
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };

  # Btrfs scrub service
  systemd.services.btrfs-scrub = lib.mkIf isBtrfs {
    description = "Btrfs filesystem scrub for data integrity";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = "${pkgs.btrfs-progs}/bin/btrfs scrub start -B /";
    };
  };

  systemd.timers.btrfs-scrub = lib.mkIf isBtrfs {
    enable = true;
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };
}
