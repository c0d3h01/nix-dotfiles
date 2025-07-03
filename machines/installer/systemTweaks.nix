{
  lib,
  pkgs,
  ...
}:

{
  services.acpid.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 3;  # Kill when <3% free (about 480MB for 16GB)
    freeSwapThreshold = 5;  # Kill when <5% swap free
    enableNotifications = true;
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = lib.mkForce "schedutil";
  };

  # I/O scheduler & USB autosuspend
  services.udev.extraRules = lib.mkForce ''
    # NVMe SSD: none (noop)
    ACTION=="add|change", KERNEL=="nvme0n1", ATTR{queue/scheduler}="none"
    # HDD: bfq (good for HDD, or use 'mq-deadline' for lowest latency)
    ACTION=="add|change", KERNEL=="sda", ATTR{queue/scheduler}="bfq"

    # USB autosuspend for power saving
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
  '';
}
