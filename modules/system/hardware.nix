{ pkgs, ... }:
{
  # powerManagement.cpuFreqGovernor = "schedutil";

  # ZRAM Swap
  zramSwap = {
    enable = true;
    swapDevices = 1;
    priority = 0;
    algorithm = "lz4";
    memoryPercent = 100;
  };
}
