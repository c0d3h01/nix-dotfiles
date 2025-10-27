{
  boot.kernel.sysctl = {
    # --- Memory and Swap Management ---
    # Kernel preference for swapping vs. freeing cache (0–100, higher = more swap usage)
    "vm.swappiness" = 100;

    # VFS cache reclaim aggressiveness (lower = retain inode/dentry cache longer)
    "vm.vfs_cache_pressure" = 50;

    # When dirty data reaches this many bytes, the process starts writing it out
    "vm.dirty_bytes" = 268435456; # 256 MB

    # When background flusher threads start writing out dirty data
    "vm.dirty_background_bytes" = 67108864; # 64 MB

    # Controls number of pages read from swap consecutively (0 = read one page)
    "vm.page-cluster" = 0;

    # Interval (in hundredths of a second) between flusher thread wakeups
    "vm.dirty_writeback_centisecs" = 1500;

    # --- Kernel & Security Settings ---
    # Disable NMI watchdog (improves performance/power use)
    "kernel.nmi_watchdog" = 0;

    # Allow unprivileged user namespaces (needed for rootless containers)
    "kernel.unprivileged_userns_clone" = 1;

    # Hide kernel messages from console
    "kernel.printk" = "3 3 3 3";

    # Restrict access to kernel pointers in /proc
    "kernel.kptr_restrict" = 2;

    # Disable kexec (prevents replacing running kernel)
    "kernel.kexec_load_disabled" = 1;

    # --- Networking ---
    # Increase backlog for incoming packets (may help prevent dropped packets)
    "net.core.netdev_max_backlog" = 4096;

    # --- Filesystem ---
    # Max number of open files/inodes system-wide
    "fs.file-max" = 2097152;
  };
}

