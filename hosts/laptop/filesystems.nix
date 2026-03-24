{lib, ...}: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [
        "subvol=/@"
        "noatime"
        "compress=zstd:1"
        "ssd"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [
        "subvol=/@home"
        "noatime"
        "compress=zstd:1"
        "ssd"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [
        "subvol=/@nix"
        "noatime"
        "compress=zstd:1"
        "ssd"
      ];
    };

    "/var/tmp" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      options = [
        "subvol=/@tmp"
        "noatime"
        "compress=zstd:1"
        "ssd"
      ];
    };

    "/var/log" = {
      device = "/dev/disk/by-label/nixos-root";
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "subvol=/@log"
        "noatime"
        "compress=zstd:1"
        "ssd"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = ["umask=0077"];
    };
  };
}
