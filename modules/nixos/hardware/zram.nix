{
  services.zram-generator = {
    enable = true;
    settings = {
      zram0 = {
        compression-algorithm = "zstd";
        fs-type = "swap";
        swap-priority = 100;
        zram-size = "ram * 2";
      };
    };
  };
}
