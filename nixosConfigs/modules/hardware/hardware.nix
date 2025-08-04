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
  inherit (userConfig.machine) gpuType;
  inherit (userConfig.machine) cpuType;

  # Dynamic kernel modules based on hardware
  cpuKernelModules =
    lib.optionals (cpuType == "amd") [
      "kvm-amd"
      "amd-pstate"
    ]
    ++ lib.optionals (cpuType == "intel") [
      "kvm-intel"
      "intel_pstate"
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

  isLaptop = userConfig.machine.type == "laptop";

  laptopKernelParams = lib.optionals isLaptop [
    "acpi_backlight=native"
    "pcie_aspm=force" # Power saving for PCIe
    "processor.max_cstate=2" # Better responsiveness
  ];
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Hardware sensors service
  systemd.services.lm-sensors = {
    description = "Initialize hardware sensors";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.lm_sensors}/bin/sensors-detect --auto";
      RemainAfterExit = true;
    };
  };

  # handle ACPI events
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  boot = {
    # Clean tmp dir on boot
    tmp.cleanOnBoot = true;

    # Kernel version
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
      "mitigations=off"
      "splash"
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "usbcore.autosuspend=-1"
      "pti=auto"
      "iommu=pt"
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
  networking.useDHCP = lib.mkDefault true;
  networking.dhcpcd.enable = lib.mkDefault true;

  # Platform detection
  nixpkgs.hostPlatform = lib.mkDefault userConfig.system;

  # CPU microcode updates - dynamic based on CPU type
  hardware.cpu.amd.updateMicrocode = lib.mkIf (cpuType == "amd") true;
  hardware.cpu.intel.updateMicrocode = lib.mkIf (cpuType == "intel") true;

  # Enable firmware updates
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Intel thermal management
  services.thermald.enable = lib.mkIf (cpuType == "intel") true;
}
