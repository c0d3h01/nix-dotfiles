{lib, ...}: {
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "lz4";
    memoryPercent = lib.mkDefault 75;
  };
}
