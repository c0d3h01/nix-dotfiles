_: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "ext4";
      options = ["noatime" "errors=remount-ro"];
    };
    "/boot" = {
      device = "/dev/disk/by-label/nixos-boot";
      fsType = "vfat";
      options = ["umask=0077"];
    };
  };
}
