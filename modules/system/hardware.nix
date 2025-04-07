{ pkgs, ... }:
{
  # ZRAM Swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };
}
