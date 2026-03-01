{lib, ...}: {
  boot.kernel.sysctl = {
    # ── Memory / Swap ──────────────────────────────────────────────────
    # 180 = recommended for zram on kernel 6.x.  Tells the kernel that
    # compressing into zram is much cheaper than disk I/O.
    "vm.swappiness" = lib.mkForce 180;

    # Keep VFS (dentry/inode) caches around longer — reclaiming them
    # causes visible latency spikes during builds.
    "vm.vfs_cache_pressure" = lib.mkForce 50;

    # ── Dirty page writeback (tuned for 6 GB RAM) ─────────────────────
    # Start background writeback at 16 MB dirty, force sync at 64 MB.
    # Previous values (256 MB / 64 MB) caused write stalls on low RAM.
    "vm.dirty_bytes" = lib.mkForce 67108864; # 64 MiB
    "vm.dirty_background_bytes" = lib.mkForce 16777216; # 16 MiB
    "vm.dirty_writeback_centisecs" = lib.mkForce 1500;

    # zram is not disk — no readahead benefit from clustering
    "vm.page-cluster" = lib.mkForce 0;

    # ── Watermarks (proactive reclamation) ─────────────────────────────
    # Wider watermark gaps give kswapd more headroom to reclaim before
    # direct reclaim stalls the UI.  Critical on ≤8 GB machines.
    "vm.watermark_boost_factor" = lib.mkForce 15000;
    "vm.watermark_scale_factor" = lib.mkForce 200;

    # ── Kernel ─────────────────────────────────────────────────────────
    # Disable NMI watchdog — saves power, reduces interrupts
    "kernel.nmi_watchdog" = lib.mkForce 0;

    # Allow unprivileged user namespaces (containers, sandboxes)
    "kernel.unprivileged_userns_clone" = lib.mkForce 1;

    # Quiet console — only critical messages
    "kernel.printk" = lib.mkForce "3 3 3 3";

    # Restrict kernel pointer leaks
    "kernel.kptr_restrict" = lib.mkForce 2;

    # ── Network ────────────────────────────────────────────────────────
    "net.core.netdev_max_backlog" = lib.mkForce 4096;
    "net.core.default_qdisc" = lib.mkForce "fq";
    "net.ipv4.tcp_congestion_control" = lib.mkForce "bbr";

    # IPv6 privacy extensions
    "net.ipv6.conf.all.use_tempaddr" = lib.mkForce 2;
    "net.ipv6.conf.default.use_tempaddr" = lib.mkForce 2;

    # ── Filesystem ─────────────────────────────────────────────────────
    "fs.file-max" = lib.mkForce 2097152;
    # Raise inotify limits for IDEs (VS Code, IntelliJ, etc.)
    "fs.inotify.max_user_watches" = lib.mkForce 524288;
    "fs.inotify.max_user_instances" = lib.mkForce 1024;
  };
}
