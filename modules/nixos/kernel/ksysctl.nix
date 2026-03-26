{
  boot.kernel.sysctl = {
    # "vm.swappiness" = 180;
    "vm.page-cluster" = 0;

    "vm.dirty_ratio" = 20;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_expire_centisecs" = 3000;
    "vm.dirty_writeback_centisecs" = 500;

    "kernel.printk" = "3 3 3 3";
  };
}
