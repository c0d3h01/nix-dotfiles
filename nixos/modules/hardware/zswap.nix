{ lib, userConfig, ... }:
let
  isLaptop = userConfig.machineConfig.laptop.enable;
in
{
  # ZRAM configuration
  zramSwap = lib.mkIf isLaptop {
    enable = true;
    priority = 1000;
    algorithm = "lzo-rle";
    memoryPercent = 200;
  };
}
