{
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    btrfs-assistant
    virtualgl
  ];

  # Enable Btrfs auto-scrub weekly (for data integrity)
  # "systemd-run -p "IOReadBandwidthMax=/dev/nvme0n1p2 10M" btrfs scrub start -B /"
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [
      "/"
    ];
  };

  # Scheduled Btrfs balance
  # "sudo btrfs balance start --enqueue -dusage=85 -musage=85 --bg /"
  # "sudo btrfs balance status /"
  systemd.timers."btrfs-balance" = {
    enable = true;
    timerConfig = {
      OnCalendar = "weekly";
      RandomizedDelaySec = "1h"; # Spread load a bit
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.services."btrfs-balance" = {
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      IOSchedulingPriority = 7;
      CPUWeight = 1;
    };
  };

  # Scheduled fstrim
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
