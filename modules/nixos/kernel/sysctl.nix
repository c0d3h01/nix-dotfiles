{lib, ...}: {
  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkForce 180;

    "vm.vfs_cache_pressure" = lib.mkForce 50;

    "vm.dirty_bytes" = lib.mkForce 67108864; # 64 MiB
    "vm.dirty_background_bytes" = lib.mkForce 16777216; # 16 MiB
    "vm.dirty_writeback_centisecs" = lib.mkForce 1500;

    "vm.page-cluster" = lib.mkForce 0;

    "vm.watermark_boost_factor" = lib.mkForce 15000;
    "vm.watermark_scale_factor" = lib.mkForce 200;

    "kernel.nmi_watchdog" = lib.mkForce 0;

    "kernel.randomize_va_space" = lib.mkForce 2;

    "kernel.unprivileged_userns_clone" = lib.mkForce 1;

    "kernel.printk" = lib.mkForce "3 3 3 3";

    "kernel.kptr_restrict" = lib.mkForce 2;

    "kernel.dmesg_restrict" = lib.mkForce 1;

    "kernel.perf_event_paranoid" = lib.mkForce 3;

    "fs.suid_dumpable" = lib.mkForce 0;

    "fs.protected_hardlinks" = lib.mkForce 1;
    "fs.protected_symlinks" = lib.mkForce 1;
    "fs.protected_fifos" = lib.mkForce 2;
    "fs.protected_regular" = lib.mkForce 2;

    "net.core.netdev_max_backlog" = lib.mkForce 4096;
    "net.core.default_qdisc" = lib.mkForce "fq";
    "net.ipv4.tcp_congestion_control" = lib.mkForce "bbr";

    "net.ipv4.tcp_syncookies" = lib.mkForce 1;
    "net.ipv4.tcp_max_syn_backlog" = lib.mkForce 4096;

    "net.ipv4.conf.all.accept_redirects" = lib.mkForce 0;
    "net.ipv4.conf.default.accept_redirects" = lib.mkForce 0;
    "net.ipv4.conf.all.send_redirects" = lib.mkForce 0;
    "net.ipv4.conf.default.send_redirects" = lib.mkForce 0;
    "net.ipv6.conf.all.accept_redirects" = lib.mkForce 0;
    "net.ipv6.conf.default.accept_redirects" = lib.mkForce 0;

    "net.ipv4.conf.all.accept_source_route" = lib.mkForce 0;
    "net.ipv4.conf.default.accept_source_route" = lib.mkForce 0;
    "net.ipv6.conf.all.accept_source_route" = lib.mkForce 0;
    "net.ipv6.conf.default.accept_source_route" = lib.mkForce 0;

    "net.ipv4.conf.all.log_martians" = lib.mkForce 1;
    "net.ipv4.conf.default.log_martians" = lib.mkForce 1;

    "net.ipv4.conf.all.rp_filter" = lib.mkForce 1;
    "net.ipv4.conf.default.rp_filter" = lib.mkForce 1;

    "net.ipv6.conf.all.use_tempaddr" = lib.mkForce 2;
    "net.ipv6.conf.default.use_tempaddr" = lib.mkForce 2;

    "fs.file-max" = lib.mkForce 2097152;
    "fs.inotify.max_user_watches" = lib.mkForce 524288;
    "fs.inotify.max_user_instances" = lib.mkForce 1024;
  };
}
