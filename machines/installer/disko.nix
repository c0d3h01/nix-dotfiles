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
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                  "--csum"
                  "xxhash64"
                  "--features"
                  "extref,skinny-metadata"
                ];

                subvolumes = {

                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd:3"
                      "ssd"
                      "noatime"
                      "space_cache=v2"
                      "commit=120"
                      "discard=async"
                      "autodefrag"
                    ];
                  };

                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd:3"
                      "ssd"
                      "noatime"
                      "space_cache=v2"
                      "commit=120"
                      "discard=async"
                      "autodefrag"
                    ];
                  };

                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd:1"
                      "ssd"
                      "noatime"
                      "space_cache=v2"
                      "commit=30"
                      "discard=async"
                      "max_inline=2048"
                    ];
                  };

                  "/@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress=zstd:6"
                      "ssd"
                      "noatime"
                      "space_cache=v2"
                      "commit=300"
                      "discard=async"
                    ];
                  };

                  "/@tmp" = {
                    mountpoint = "/tmp";
                    mountOptions = [
                      "ssd"
                      "noatime"
                      "space_cache=v2"
                      "nodatacow"
                      "nodatasum"
                      "commit=300"
                      "discard=async"
                    ];
                  };

                  "/@containers" = {
                    mountpoint = "/var/lib/containers";
                    mountOptions = [
                      "compress=zstd:1"
                      "ssd"
                      "noatime"
                      "space_cache=v2"
                      "nodatacow"
                      "commit=60"
                      "discard=async"
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
