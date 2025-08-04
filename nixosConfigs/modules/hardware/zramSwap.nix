{
  userConfig,
  ...
}:
let
  isLaptop = userConfig.machine.type == "laptop";
in
{
  # ZRAM configuration
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lzo-rle";
    memoryPercent = if isLaptop then 200 else 100;
  };
}
