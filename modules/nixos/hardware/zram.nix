{
  lib,
  userConfig,
  ...
}: {
  # Prefer ZRAM with zswap disabled to keep memory pressure predictable.
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "laz4";
    memoryPercent = lib.mkDefault 100;
  };
}
