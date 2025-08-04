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

  # Get all Btrfs filesystems for scrubbing
  btrfsFilesystems = lib.filter (fs: fs.fsType == "btrfs") (lib.attrValues config.fileSystems);

  # Extract mount points of Btrfs filesystems
  btrfsMountPoints = map (fs: fs.mountPoint) btrfsFilesystems;
in
{
  # Only install Btrfs tools if we have Btrfs filesystems
  environment.systemPackages = lib.mkIf isBtrfs (
    with pkgs;
    [
      btrfs-assistant
      btrfs-progs # Essential Btrfs utilities
      compsize # Check compression ratios
    ]
  );

  # Enable Btrfs auto-scrub weekly (for data integrity) - only if Btrfs detected
  services.btrfs.autoScrub = lib.mkIf isBtrfs {
    enable = true;
    interval = "weekly";
    # Automatically scrub all detected Btrfs filesystems
    fileSystems = btrfsMountPoints;
  };

  # Scheduled Btrfs balance - only if root is Btrfs
  systemd.timers."btrfs-balance" = lib.mkIf isBtrfs {
    enable = true;
    timerConfig = {
      OnCalendar = "Sun *-*-* 02:00:00"; # Run Sunday at 2 AM
      RandomizedDelaySec = "1h"; # Spread load a bit
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.services."btrfs-balance" = lib.mkIf isBtrfs {
    description = "Btrfs filesystem balance";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19; # Low priority
      IOSchedulingClass = "idle"; # Idle I/O priority
      IOSchedulingPriority = 7; # Lowest idle priority
      CPUWeight = 1; # Minimal CPU weight
      # Balance with conservative usage threshold
      ExecStart = "${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=50 -musage=50 /";
      # Ensure btrfs-progs is available
      Environment = "PATH=${pkgs.btrfs-progs}/bin:$PATH";
    };
    # Only run if root filesystem is mounted and healthy
    requisite = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
  };

  # Optional: Add a notification service for balance completion
  systemd.services."btrfs-balance-notify" = lib.mkIf isBtrfs {
    description = "Notify when Btrfs balance completes";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemd-cat -t btrfs-balance echo 'Btrfs balance completed successfully'";
    };
    # Run after balance completes successfully
    requisite = [ "btrfs-balance.service" ];
    after = [ "btrfs-balance.service" ];
    wantedBy = [ "btrfs-balance.service" ];
  };
}
