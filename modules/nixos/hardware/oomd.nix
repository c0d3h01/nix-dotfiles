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
  };
}
