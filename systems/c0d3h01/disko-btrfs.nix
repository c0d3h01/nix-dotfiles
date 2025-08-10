{
  disko.devices = {
    disk = {
      nvme = {
        device = "/dev/nvme0n1";
        type = "disk";
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
                mountpoint = "/boot/efi";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };

            plainSwap = {
              label = "nixos-swap";
              size = "12G";
              content = {
                type = "swap";
                discardPolicy = "both":
                resumeDevice = true;
              };
            };

            root = {
              label = "nixos-root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:1"
                      "ssd"
                      "commit=120"
                    ];
                  };

                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:1"
                      "ssd"
                      "commit=120"
                    ];
                  };

                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:3" # Higher compression
                      "ssd"
                      "commit=120"
                    ];
                  };

                  "/@srv" = {
                    mountpoint = "/srv";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:1"
                      "ssd"
                      "commit=120"
                    ];
                  };

                  "/@cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = [
                      "nodatacow"
                      "nodatasum"
                      "ssd"
                      "commit=120"
                    ];
                  };

                  "/@tmp" = {
                    mountpoint = "/var/tmp";
                    mountOptions = [
                      "nodatacow"
                      "ssd"
                      "commit=120"
                    ];
                  };

                  "/@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "nodatacow"
                      "ssd"
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
