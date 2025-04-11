{ pkgs, ... }:
{
  # powerManagement.cpuFreqGovernor = "schedutil";

  # ZRAM Swap
  zramSwap = {
    enable = true;
    swapDevices = 1;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
