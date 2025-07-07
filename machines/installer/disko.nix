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
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                ];

                subvolumes = {
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                      "commit=120"
                    ];
                  };

                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                      "commit=120"
                    ];
                  };

                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                      "commit=120"
                    ];
                  };

                  "/@srv" = {
                    mountpoint = "/srv";
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                      "commit=120"
                    ];
                  };

                  "/@cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                      "commit=120"
                    ];
                  };

                  "/@tmp" = {
                    mountpoint = "/var/tmp";
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                      "commit=120"
                    ];
                  };

                  "/@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
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
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "noatime"
          "mode=1777"
        ];
      };
    };
  };
}
