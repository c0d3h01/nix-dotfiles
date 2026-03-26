{
  systemd = {
    oomd = {
      enable = true;
      enableRootSlice = true;
      enableUserSlices = true;
      enableSystemSlice = true;

      # Hardcoded for 6GB RAM: React faster (3s) at lower pressure (60%)
      settings.OOM = {
        DefaultMemoryPressureLimit = "60%";
        DefaultMemoryPressureDurationSec = "3s";
        # Since we have ample ZRAM, we can be less aggressive on swap limit
        DefaultSwapUsedLimit = "90%";
        PreferredMemoryPressureLimit = "95%";
      };
    };

    services = {
      # Protect the kernel and init system
      systemd-journald.serviceConfig.OOMScoreAdjust = -1000;
      systemd-udevd.serviceConfig.OOMScoreAdjust = -1000;

      # Make GNOME shell harder to kill than apps, but easier than kernel
      "gdm.service".serviceConfig.OOMScoreAdjust = -500;

      # Nix builds are memory hungry; kill them first if needed
      nix-daemon.serviceConfig.OOMScoreAdjust = 500;
    };
  };
}
