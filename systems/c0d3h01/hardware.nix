{
  disko.devices = {
    disk = {
      nvme = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition (ESP)
            ESP = {
              label = "nixos-boot";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };
            # Swap partition
            swap = {
              label = "nixos-swap";
              size = "6G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            # Root partition (Btrfs)
            root = {
              label = "nixos-root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  # Root subvolume
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:1"
                      "ssd"
                      "space_cache=v2"
                      "commit=120"
                    ];
                  };
                  # Home subvolume
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:1"
                      "ssd"
                      "space_cache=v2"
                      "commit=120"
                    ];
                  };
                  # Nix store subvolume
                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:7"
                      "ssd"
                      "space_cache=v2"
                      "commit=120"
                    ];
                  };
                  # Cache subvolume
                  "/@cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = [
                      "noatime"
                      "nodatacow"
                      "ssd"
                      "space_cache=v2"
                      "commit=120"
                    ];
                  };
                  # Log subvolume
                  "/@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:1"
                      "ssd"
                      "space_cache=v2"
                      "commit=120"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
