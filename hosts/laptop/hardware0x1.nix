{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "nixos-boot";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            plainSwap = {
              label = "nixos-swap";
              size = "8G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
                # priority = 100;
              };
            };

            root = {
              label = "nixos-root";
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                  "noatime" # Reduces unnecessary writes
                  "inode64" # Required for modern systems
                  "logbsize=256k" # Larger log buffer for better metadata performance
                  "largeio" # Optimizes I/O size for large, sequential operations
                ];
              };
            };
          };
        };
      };
    };
  };
}
