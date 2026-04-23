{
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/nix-boot";
    fsType = "vfat";

    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nix-root";
    fsType = "btrfs";

    options = [
      "subvol=@"
      "noatime"
      "compress=zstd"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/nix-root";
    fsType = "btrfs";

    options = [
      "subvol=@home"
      "noatime"
      "compress=zstd"
    ];
  };

  # swapDevices = [
  #   {device = "/dev/disk/by-label/nix-swap";}
  # ];
}
