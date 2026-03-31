{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  boot.kernel.sysctl = mkIf config.zramSwap.enable {
    # zram is relatively cheap, prefer swap
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    # zram is in memory, no need to readahead
    "vm.page-cluster" = 0;
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lzo-rle";
    memoryPercent = 200;
  };

  # services.zram-generator = {
  #   enable = true;
  #   settings = {
  #     zram0 = {
  #       compression-algorithm = "lzo-rle";
  #       fs-type = "swap";
  #       swap-priority = 100;
  #       zram-size = "ram * 2";
  #     };
  #   };
  # };
}
