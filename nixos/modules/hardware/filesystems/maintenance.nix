{
  pkgs,
  config,
  lib,
  ...
}:
let
  # Auto-detect if root filesystem is Btrfs
  rootFilesystem = config.fileSystems."/".fsType;
  isBtrfs = rootFilesystem == "btrfs";
in
{
  # Only install Btrfs tools if we have Btrfs filesystems
  environment.systemPackages = lib.mkIf isBtrfs (
    with pkgs;
    [
      # btrfs-assistant
      btrfs-progs # Essential Btrfs utilities
      compsize # Check compression ratios
    ]
  );

  # Automatic scrub for data integrity
  services.btrfs.autoScrub = lib.mkIf isBtrfs {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  # Lightweight balance to prevent metadata fragmentation
  systemd.services."btrfs-balance" = lib.mkIf isBtrfs {
    description = "Btrfs balance (lightweight)";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = "${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=75 -musage=75 /";
    };
  };

  systemd.timers."btrfs-balance" = lib.mkIf isBtrfs {
    enable = true;
    timerConfig = {
      OnCalendar = "monthly";
      RandomizedDelaySec = "2h"; # Spread load
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  # Scheduled fstrim
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}

