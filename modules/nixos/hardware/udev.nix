# Hardware — udev rules for storage I/O scheduling and disk power management
{pkgs, ...}: {
  services.udev.extraRules = ''
    # ── I/O Schedulers ────────────────────────────────────────────────────
    # HDD — BFQ gives fair bandwidth with low latency
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", \
        ATTR{queue/scheduler}="bfq"

    # SSD / eMMC — mq-deadline balances throughput and latency
    ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", \
        ATTR{queue/scheduler}="mq-deadline"

    # NVMe — no scheduler (hardware handles it)
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", \
        ATTR{queue/scheduler}="none"

    # ── HDD Power Management ─────────────────────────────────────────────
    # APM level 254 = max performance, spindown disabled
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", \
      ATTRS{id/bus}=="ata", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"

    # ── SATA Link Power Management ────────────────────────────────────────
    # Max performance prevents ALPM sleep-state latency spikes
    ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", \
      ATTR{link_power_management_policy}="max_performance"
  '';
}
