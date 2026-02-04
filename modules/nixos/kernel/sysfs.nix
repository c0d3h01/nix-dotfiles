{lib, ...}: {
  boot.kernel.sysfs = {
    kernel.mm.transparent_hugepage = {
      enabled = lib.mkDefault "always";
      defrag = lib.mkDefault "defer";
      shmem_enabled = lib.mkDefault "within_size";
    };
  };
}
