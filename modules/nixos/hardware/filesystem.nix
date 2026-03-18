{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  rootFs = config.fileSystems."/".fsType;
  isBtrfs = rootFs == "btrfs";
in {

  environment.systemPackages = mkMerge [
    (mkIf isBtrfs [pkgs.btrfs-progs])
  ];

  services.fstrim.enable = mkDefault true;

  systemd.services.btrfs-scrub = mkIf isBtrfs {
    description = "Btrfs filesystem scrub for data integrity";
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = "${pkgs.btrfs-progs}/bin/btrfs scrub start -B /";
    };
  };

  systemd.timers.btrfs-scrub = mkIf isBtrfs {
    enable = true;
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };
}
