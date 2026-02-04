{
  lib,
  userConfig,
  ...
}: {
  # Prefer ZRAM with zswap disabled to keep memory pressure predictable.
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "zstd";
    memoryPercent = lib.mkDefault 100;
  };
}
