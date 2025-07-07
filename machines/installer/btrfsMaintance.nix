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
      "/home"
      "/nix"
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
    script = ''
      # Only run if system is on AC (laptop check)
      if command -v upower >/dev/null && upower -i $(upower -e | grep BAT) | grep -q 'state:\s*discharging'; then
        echo "On battery, skipping btrfs balance"
        exit 0
      fi

      # Start a limited balance (data and metadata chunks >75% usage)
      /run/current-system/sw/bin/btrfs balance start -dusage=75 -musage=75 -susage=75 -v --background --noflush /
    '';
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
    interval = "daily";
  };
}
