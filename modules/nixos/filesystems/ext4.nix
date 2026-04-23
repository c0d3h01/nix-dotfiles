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
    fsType = "ext4";

    options = [
      "noatime"
      "commit=60"
      "discard"
    ];
  };

  # fileSystems.swapDevices = [
  #   {device = "/dev/disk/by-label/nix-swap";}
  # ];
}
