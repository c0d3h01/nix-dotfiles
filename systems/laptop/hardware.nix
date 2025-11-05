{
  disko.devices = {
    disk.main = {
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
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            label = "nixos-swap";
            size = "8G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };

          luks = {
            label = "nixos-root";
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings = {
                bypassWorkqueues = true;
              };
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {

                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:3"
                      "ssd"
                      "space_cache=v2"
                    ];
                  };

                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:3"
                      "ssd"
                      "space_cache=v2"
                    ];
                  };

                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:3"
                      "ssd"
                      "space_cache=v2"
                    ];
                  };

                  "/@tmp" = {
                    mountpoint = "/var/tmp";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:3"
                      "ssd"
                      "space_cache=v2"
                    ];
                  };

                  "/@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "noatime"
                      "compress=zstd:3"
                      "ssd"
                      "space_cache=v2"
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