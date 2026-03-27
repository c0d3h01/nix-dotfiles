_: {
  fileSystems = {
    "/" = {
      device = "zpool/root";
      fsType = "zfs";
    };
    "/home" = {
      device = "zpool/home";
      fsType = "zfs";
    };
    "/nix" = {
      device = "zpool/nix";
      fsType = "zfs";
    };
    "/var/log" = {
      device = "zpool/log";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-label/nixos-boot";
      fsType = "vfat";
      options = ["umask=0077"];
    };
  };

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
}
