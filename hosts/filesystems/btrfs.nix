_: let
  rootDev = "/dev/disk/by-label/nixos-root";
  btrfsOpts = [
    "noatime"
    "compress=zstd:1"
    "ssd"
    "space_cache=v2"
    "discard=async"
  ];
in {
  fileSystems."/" = {
    device = rootDev;
    fsType = "btrfs";
    options = ["subvol=/@"] ++ btrfsOpts;
  };

  fileSystems."/home" = {
    device = rootDev;
    fsType = "btrfs";
    options = ["subvol=/@home"] ++ btrfsOpts;
  };

  fileSystems."/nix" = {
    device = rootDev;
    fsType = "btrfs";
    options = ["subvol=/@nix"] ++ btrfsOpts;
  };

  fileSystems."/var/tmp" = {
    device = rootDev;
    fsType = "btrfs";
    options = ["subvol=/@tmp"] ++ btrfsOpts;
  };

  fileSystems."/var/log" = {
    device = rootDev;
    fsType = "btrfs";
    neededForBoot = true;
    options = ["subvol=/@log"] ++ btrfsOpts;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/nixos-boot";
    fsType = "vfat";
    options = ["umask=0077"];
  };
}
