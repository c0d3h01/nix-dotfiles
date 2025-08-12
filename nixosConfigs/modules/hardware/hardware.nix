{
  config,
  lib,
  pkgs,
  userConfig,
  modulesPath,
  ...
}:
let
  # Get CPU & GPU types
  inherit (userConfig.machineConfig) gpuType;
  inherit (userConfig.machineConfig) cpuType;

  # Dynamic kernel modules based on hardware
  cpuKernelModules =
    lib.optionals (cpuType == "amd") [
      "kvm-amd"
    ]
    ++ lib.optionals (cpuType == "intel") [
      "kvm-intel"
    ];

  gpuKernelModules =
    lib.optionals (gpuType == "amd") [
      "amdgpu"
    ]
    ++ lib.optionals (gpuType == "nvidia") [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ]
    ++ lib.optionals (gpuType == "intel") [
      "i915"
    ];

  # Dynamic kernel parameters
  cpuKernelParams =
    lib.optionals (cpuType == "amd") [
      "amd_pstate=active"
    ]
    ++ lib.optionals (cpuType == "intel") [
      "intel_pstate=active"
    ];

  isLaptop = userConfig.machineConfig.type == "laptop";

  laptopKernelParams = lib.optionals isLaptop [
    "acpi_backlight=native"
    "pcie_aspm=performance"
    "processor.max_cstate=2" # Better responsiveness
  ];
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # handle ACPI events
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  # Scheduled fstrim
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # ZRAM configuration
  zramSwap = lib.mkIf isLaptop {
    enable = true;
    priority = 50;
    algorithm = "lz4";
    memoryPercent = 100;
  };

  boot = {
    # Clean tmp dir on boot
    tmp.cleanOnBoot = true;

    # Latest Kernel Version
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [
      "acpi_call"
      "fuse"
    ]
    ++ cpuKernelModules
    ++ gpuKernelModules;

    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      cpupower
    ];

    supportedFilesystems = [
      "ntfs"
      "cifs"
      "nfs"
    ];

    kernelParams = [
      "nowatchdog"
      "splash"
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "usbcore.autosuspend=-1"
      "pti=auto"
    ]
    ++ cpuKernelParams
    ++ laptopKernelParams;

    initrd = {
      verbose = false;
      compressor = "zstd";
      compressorArgs = [
        "-3"
        "-T0"
      ];

      kernelModules = [
        "nvme"
        "btrfs"
        "ahci"
        "sd_mod"
        "dm_mod"
        "xhci_pci"
      ]
      ++ lib.optionals (gpuType == "amd") [ "amdgpu" ]
      ++ lib.optionals (gpuType == "intel") [ "i915" ];

      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "dm_mod"
        "sr_mod"
      ];
    };
  };

  # Network configuration
  networking.useDHCP = lib.mkDefault false;
  networking.dhcpcd.enable = lib.mkDefault false;

  # Platform detection
  nixpkgs.hostPlatform = lib.mkDefault userConfig.system;

  # CPU microcode updates - dynamic based on CPU type
  hardware.cpu.amd.updateMicrocode = lib.mkIf (cpuType == "amd") true;
  hardware.cpu.intel.updateMicrocode = lib.mkIf (cpuType == "intel") true;

  # Enable firmware updates
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Intel thermal management
  services.thermald.enable = lib.mkIf (cpuType == "intel" && lib.mkIf isLaptop) true;
}
