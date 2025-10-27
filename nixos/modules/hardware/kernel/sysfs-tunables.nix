{
  boot.kernel.sysfs = {
    kernel.mm.transparent_hugepage = {
      enabled = "madvise";
      defrag = "never";
      shmem_enabled = "never";
    };
  };
}

