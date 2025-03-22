{ ... }:

{
  # System optimization
  boot = {
    tmp.cleanOnBoot = true;
    kernelParams = [
      # CPU optimizations
      "amd_pstate=active" # Uses AMD's performance scaling

      # GPU optimizations
      "amdgpu.ppfeaturemask=0xffffffff" # Enable all power features including overclocking
      "amdgpu.dc=1" # Enable Display Core for better display performance

      # I/O optimizations
      "elevator=none" # Use OS I/O scheduler, better for SSDs
      "scsi_mod.use_blk_mq=1" # Enable multi-queue for SCSI devices
    ];

    kernel.sysctl = {
      # File system optimizations
      "fs.inotify.max_user_watches" = 524288; # Higher value for development environments

      # Process and memory optimizations
      "vm.swappiness" = 10; # Minimize swap usage, keep more in RAM
      "vm.dirty_ratio" = 30; # Allow more dirty pages in memory before writing
      "vm.dirty_background_ratio" = 10; # Start writing dirty pages at 10%
      "vm.dirty_expire_centisecs" = 3000; # Keep dirty pages longer (120 seconds)
      "vm.dirty_writeback_centisecs" = 6000; # Check to write dirty pages less often (60 seconds)
      "vm.vfs_cache_pressure" = 50; # Keep directory/inode caches longer
      "vm.min_free_kbytes" = 65536; # Keep more free memory

      # Network performance
      "net.core.netdev_max_backlog" = 16384; # Increase network processing backlog
      "net.core.somaxconn" = 8192; # Increase connection backlog
      "net.ipv4.tcp_fastopen" = 3; # Enable TCP Fast Open for both client and server
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.rmem_max" = 16777216; # Increase TCP read buffer size
      "net.core.wmem_max" = 16777216; # Increase TCP write buffer size
      "net.ipv4.tcp_tw_reuse" = 1; # Allow reuse of TIME_WAIT sockets
      "net.ipv4.tcp_max_syn_backlog" = 8192; # Larger SYN backlog
      "net.ipv4.tcp_max_tw_buckets" = 262144; # Increase TIME_WAIT buckets
      "net.ipv4.ip_local_port_range" = "1024 65535"; # Wider port range for connections
    };
  };

  services = {

    thermald = {
      enable = true;
    };

    fstrim = {
      enable = true;
      interval = "weekly"; # Run TRIM weekly for SSDs
    };

    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "performance";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 1;
      };
    };
  };
}
