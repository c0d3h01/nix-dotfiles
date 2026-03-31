{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3fd07a5f-708c-46a2-ae6c-86b6eec90160";
    fsType = "ext4";
    options = ["noatime" "discard"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DE14-CB68";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/c4cb41b4-d238-4767-b6df-00855480eb7d";}
  ];

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/nix-root";
  #     fsType = "ext4";
  #     options = ["noatime"];
  #   };
  #   "/boot" = {
  #     device = "/dev/disk/by-label/nix-boot";
  #     fsType = "vfat";
  #     options = ["fmask=0077" "dmask=0077"];
  #   };
  #   swapDevices = [
  #     { device = "/dev/disk/by-label/nix-swap"; }
  #   ];
  # };
}
