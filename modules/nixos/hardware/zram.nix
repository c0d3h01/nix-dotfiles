{
  services.zram-generator = {
    enable = true;
    settings = {
      zram0 = {
        compression-algorithm = "lz4";
        fs-type = "swap";
        swap-priority = 200;
        zram-size = "ram * 2";
      };
    };
  };
}
